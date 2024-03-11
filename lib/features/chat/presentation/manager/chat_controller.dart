import 'package:api_handler/api_handler.dart';
import 'package:api_handler/feature/api_handler/data/models/response_model.dart';
import 'package:get/get.dart';
import 'package:messaging_core/app/theme/constants.dart';
import 'package:messaging_core/core/app_states/app_global_data.dart';
import 'package:messaging_core/core/app_states/result_state.dart';
import 'package:messaging_core/core/enums/change_message_modes.dart';
import 'package:messaging_core/core/enums/content_type_enum.dart';
import 'package:messaging_core/core/enums/message_status.dart';
import 'package:messaging_core/core/enums/receiver_type.dart';
import 'package:messaging_core/core/services/media_handler/file_model.dart';
import 'package:messaging_core/core/services/network/websocket/messaging_client.dart';
import 'package:messaging_core/core/utils/utils.dart';
import 'package:messaging_core/features/chat/data/models/get_messages_model.dart';
import 'package:messaging_core/features/chat/data/models/users_groups_category.dart';
import 'package:messaging_core/features/chat/domain/entities/category_users.dart';
import 'package:messaging_core/features/chat/domain/entities/chats_parent_model.dart';
import 'package:messaging_core/features/chat/domain/entities/content_model.dart';
import 'package:messaging_core/features/chat/domain/entities/content_payload_model.dart';
import 'package:messaging_core/features/chat/domain/repositories/storage/chat_storage_repository.dart';
import 'package:messaging_core/features/chat/domain/use_cases/group/create_group_use_case.dart';
import 'package:messaging_core/features/chat/domain/use_cases/delete_message_use_case.dart';
import 'package:messaging_core/features/chat/domain/use_cases/edit_message_use_case.dart';
import 'package:messaging_core/features/chat/domain/use_cases/get_all_chats_use_case.dart';
import 'package:messaging_core/features/chat/domain/use_cases/get_messages_use_case.dart';
import 'package:messaging_core/features/chat/domain/use_cases/pin_message_use_case.dart';
import 'package:messaging_core/features/chat/domain/use_cases/send_messags_use_case.dart';
import 'package:messaging_core/features/chat/domain/use_cases/update_read_use_case.dart';
import 'package:messaging_core/features/chat/presentation/manager/connection_status_controller.dart';
import 'package:messaging_core/features/chat/presentation/manager/emoji_controller.dart';
import 'package:messaging_core/features/chat/presentation/manager/record_voice_controller.dart';
import 'package:messaging_core/locator.dart';

class ChatController extends GetxController {
  final GetAllChatsUseCase getAllChatsUseCase;
  final GetMessagesUseCase getMessagesUseCase;
  final SendMessagesUseCase sendMessageUsecase;
  final EditMessagesUseCase editMessagesUseCase;
  final CreateGroupUseCase createGroupUseCase;
  final DeleteMessageUseCase deleteMessageUseCase;
  final UpdateReadUseCase updateReadUseCase;
  final PinMessageUseCase pinMessageUseCase;
  final ChatStorageRepository chatStorageRepository;
  final MessagingClient messagingClient;

  ChatController(
      this.getAllChatsUseCase,
      this.getMessagesUseCase,
      this.sendMessageUsecase,
      this.messagingClient,
      this.editMessagesUseCase,
      this.deleteMessageUseCase,
      this.updateReadUseCase,
      this.pinMessageUseCase,
      this.chatStorageRepository,
      this.createGroupUseCase);

  RequestStatus chatsStatus = RequestStatus();
  RequestStatus messagesStatus = RequestStatus();

  List<ChatParentClass> chats = [];
  List<ContentModel> messages = [];
  List<CategoryUser> users = [];
  bool isTyping = false;
  ContentModel? editingContent;
  ContentModel? repliedContent;
  List<ContentModel>? pinnedMessages;
  ContentModel? pinnedMessage;
  late ChatParentClass? currentChat;
  late String? _roomIdentifier;

  void setCurrentChat(ChatParentClass value) {
    currentChat = value;
  }

  resetState() {
    messages = [];
    users = [];
    currentChat = null;
    repliedContent = null;
    _roomIdentifier = null;
    isTyping = false;
    editingContent = null;
    pinnedMessages = [];
    pinnedMessage = null;
  }

  getAllChats({bool showLoading = true}) async {
    try {
      if (showLoading) {
        chatsStatus.loading();
        update(["allChats"]);
      }
      chats = [];
      users = [];

      ResponseModel response = await getAllChatsUseCase(null);
      if (response.result == ResultEnum.success) {
        if (!locator<ConnectionStatusProvider>().isConnected) {
          chats.addAll(response.data);
        } else {
          UsersAndGroupsInCategory usersAndGroupsInCategory = response.data;

          users.addAll(usersAndGroupsInCategory.users);

          chats.addAll(usersAndGroupsInCategory.users);
          chats.addAll(usersAndGroupsInCategory.groups);

          chats.sort((a, b) =>
              ((b.lastMessage?.updatedAt ?? b.updatedAt) ?? DateTime(1998))
                  .compareTo(((a.lastMessage?.updatedAt ?? a.updatedAt) ??
                      DateTime(1998))));
          addStarChat();
        }

        chatsStatus.success();
        update(["allChats"]);
      }
    } catch (e) {
      chatsStatus.error(e.toString());
      update(["allChats"]);
    }
  }

  getMessages() async {
    try {
      Future.delayed(const Duration(milliseconds: 100), () {
        messagesStatus.loading();
        update(["messages"]);
      });

      if (locator<ConnectionStatusProvider>().isConnected) {
        ResponseModel response = await getMessagesUseCase(GetMessagesParams(
          receiverType: currentChat!.getReceiverType(),
          receiverId: currentChat!.id!,
          senderId: currentChat!.isGroup() ? null : AppGlobalData.userId,
        ));
        if (response.result == ResultEnum.success) {
          messages = (response.data as GetMessagesModel).messages;
          if ((response.data as GetMessagesModel).pinnedMessages.isNotEmpty) {
            pinnedMessages = (response.data as GetMessagesModel).pinnedMessages;
            setPinnedMessage();
          }
          // messages = messages.reversed.toList();
          updateReadStatus();
          saveMessages();

          messagesStatus.success();
          update(["messages"]);
        }
      } else {
        messages = await getMessagesTable();
        messages = messages.reversed.toList();
        messagesStatus.success();
        update(["messages"]);
      }
    } catch (e) {
      messagesStatus.error(e.toString());
      update(["messages"]);
    }
  }

  sendTextMessage(String text, int receiverId, ContentTypeEnum? contentType,
      FileModel? file, ContentPayloadModel? contentPayload) async {
    try {
      int uniqueId = generateUniqueId();
      ContentModel content = ContentModel(
          contentId: uniqueId,
          senderId: AppGlobalData.userId,
          receiverType: currentChat!.getReceiverType(),
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          contentType: contentType ?? ContentTypeEnum.text,
          contentPayload: contentPayload,
          messageText: text,
          replied: repliedContent,
          pinned: 0,
          filePath: file?.filePath,
          categoryId: AppGlobalData.categoryId,
          receiverId: receiverId,
          status: MessageStatus.sending);
      repliedContent = null;
      messages.insert(0, content);
      update(["messages", "sendMessage"]);

      ResponseModel response = await sendMessageUsecase(SendMessagesParams(
        contentModel: content,
        file: file,
      ));
      if (response.result == ResultEnum.success) {
        int index =
            messages.indexWhere((element) => element.contentId == uniqueId);
        messages[index].contentId = (response.data as ContentModel).contentId;
        if (file != null) {
          messages[index].filePath = (response.data as ContentModel).filePath;
        }
        messages[index].status = MessageStatus.sent;

        messagingClient.sendUserContent(messages[index], _roomIdentifier!);

        update(["messages"]);
      }
    } catch (e) {
      print("----${e.toString()}----");
    }
  }

  Future<ResponseModel> createNewGroup(
      String groupName, List<int> users, FileModel? file) async {
    try {
      ResponseModel response = await createGroupUseCase(
          CreateGroupParams(groupName: groupName, users: users, file: file));
      return response;
    } catch (e) {
      return ResponseModel(result: ResultEnum.error);
    }
  }

  editTextMessage(String newMessage, int messageId) async {
    int messageIndex =
        messages.indexWhere((element) => element.contentId == messageId);
    try {
      editingContent = null;
      update(["sendMessage"]);

      messages[messageIndex].messageText = newMessage;

      ResponseModel response = await editMessagesUseCase(
          EditMessagesParams(newMessage: newMessage, messageId: messageId));

      if (response.result == ResultEnum.success) {
        messagingClient.sendChangeMessage(
            roomIdentifier: _roomIdentifier!,
            changeMessageType: ChangeMessageEnum.edit,
            messageId: messageId,
            data: newMessage);

        messages[messageIndex].messageText = editingContent!.messageText;
      }
      editingContent = null;
    } catch (e) {
      messages[messageIndex].messageText = editingContent!.messageText;
      editingContent = null;

      print("----${e.toString()}----");
    }
  }

  attachContact(
      {required int receiverId,
      required String text,
      required ContentTypeEnum contentType,
      required ContentPayloadModel content}) {
    sendTextMessage(text, receiverId, contentType, null, content);
  }

  joinRoom() {
    if (currentChat!.isGroup()) {
      List<int> ids = [currentChat!.id!, AppGlobalData.categoryId];
      _roomIdentifier = ids.join('-');
    } else {
      List<int> ids = [
        AppGlobalData.userId,
        currentChat!.id!,
        AppGlobalData.categoryId
      ];

      ids.sort();
      _roomIdentifier = ids.join('-');
    }
    print("---------$_roomIdentifier ----");

    messagingClient.sendJoinRoom(_roomIdentifier!);
  }

  Future<bool> starMessage(
      String text,
      int receiverId,
      ContentTypeEnum? contentType,
      FileModel? file,
      ContentPayloadModel? contentPayload) async {
    int uniqueId = generateUniqueId();
    ContentModel content = ContentModel(
      contentId: uniqueId,
      senderId: AppGlobalData.userId,
      receiverType: ReceiverType.user,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      contentType: contentType ?? ContentTypeEnum.text,
      contentPayload: contentPayload,
      messageText: text,
      replied: null,
      pinned: 0,
      filePath: file?.filePath,
      categoryId: AppGlobalData.categoryId,
      receiverId: receiverId,
    );

    ResponseModel response = await sendMessageUsecase(SendMessagesParams(
      contentModel: content,
      file: file,
    ));
    if (response.result == ResultEnum.success) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> deleteMessage(int messageId) async {
    ResponseModel response = await deleteMessageUseCase(messageId);

    if (response.result == ResultEnum.success) {
      messagingClient.sendChangeMessage(
          roomIdentifier: _roomIdentifier!,
          changeMessageType: ChangeMessageEnum.delete,
          messageId: messageId);

      messages.removeWhere((element) => element.contentId == messageId);
      update(["messages"]);
      return true;
    } else {
      return false;
    }
  }

  deleteMessageFromSocket(int messageId, String roomIdentifier) {
    if (_roomIdentifier == roomIdentifier) {
      messages.removeWhere((content) => content.contentId == messageId);
      update(["messages"]);
    }
  }

  editMessageFromSocket(
      int messageId, String roomIdentifier, String newMessage) {
    if (_roomIdentifier == roomIdentifier) {
      ContentModel? itemToEdit = messages.firstWhereOrNull(
        (content) => content.contentId == messageId,
      );
      if (itemToEdit != null) {
        itemToEdit.messageText = newMessage;
      }

      update(["messages"]);
    }
  }

  Future pinMessage(int messageId, bool pin) async {
    try {
      if (pin == false) {
        unPinAllMessages();
      } else {
        unPinAllMessages();
        pinDesignatedMessage(messageId);
      }
      update(["messages"]);
    } catch (e) {
      print(e);
    }
  }

  updateReadStatus() {
    for (int i = 0; i < messages.length; i++) {
      if (messages[i].senderId != AppGlobalData.userId) {
        updateReadUseCase(messages[0].contentId);
        break;
      }
    }
  }

  addStarChat() {
    chats.add(ChatParentClass(
      id: AppGlobalData.userId,
      name: "Starred Chat",
    ));
  }

  setPinnedMessage() {
    if (pinnedMessages != null) {
      pinnedMessages?.sort((a, b) => a.updatedAt.compareTo(b.updatedAt));
      pinnedMessage = pinnedMessages?.first;
      update(["pin"]);

      unPinAllMessages();
      pinDesignatedMessage(pinnedMessage!.contentId);
    }
  }

  unPinAllMessages() {
    pinnedMessages!.forEach((element) {
      ContentModel foundItem = messages
          .firstWhere((content) => content.contentId == element.contentId);
      foundItem.pinned = 0;

      pinMessageUseCase(PinMessageParams(element.contentId, false));
    });
    pinnedMessages = [];
  }

  pinDesignatedMessage(int messageId) {
    messages.firstWhere((element) {
      if (element.contentId == messageId) {
        pinnedMessages?.add(element);
        element.pinned = 1;
        return true;
      }
      return false;
    });
    pinMessageUseCase(PinMessageParams(messageId, true));
  }

  handleReceivedMessages(Map<String, dynamic> json, String roomIdentifier) {
    ContentModel content = ContentModel.fromSocketJson(json);
    if (currentChat != null) {
      if (_roomIdentifier == roomIdentifier) {
        messages.insert(0, content);
        update(["messages"]);
      }
    }
  }

  handleNotificationSignal(int chatId, ReceiverType receiverType) async {
    await getAllChats(showLoading: false);
    for (var element in chats) {
      if (element.id == chatId) {
        locator<RecordVoiceController>()
            .playSimpleAudio(Assets.notificationTone);
        break;
      }
    }
  }

  handleUserTypingSignal(int senderId) {
    if (currentChat?.id == senderId) {
      isTyping = true;
      update(["isTyping"]);
    }
  }

  handleUserStoppedTypingSignal(int senderId) {
    if (currentChat?.id == senderId) {
      isTyping = false;
      update(["isTyping"]);
    }
  }

  sendUserTyping() {
    messagingClient.sendTyping();
  }

  sendUserStoppedTyping() {
    messagingClient.sendStopTyping();
  }

  sendLeaveRoomEvent() {
    messagingClient.sendLeaveRoomEvent(_roomIdentifier!);
  }

  onBackButtonOnChatPage() {
    final EmojiController emojiController = Get.find<EmojiController>();

    if (isTyping) {
      sendUserStoppedTyping();
    }
    emojiController.stopShowingEmoji();
    getAllChats(showLoading: false);
    sendLeaveRoomEvent();
    resetState();
  }

  Future<List<ContentModel>> getMessagesTable() async {
    List<ContentModel> contents =
        await chatStorageRepository.getMessages(_roomIdentifier!);
    return contents;
  }

  saveMessages() async {
    print(messages);
    await chatStorageRepository.saveMessages(messages, _roomIdentifier!);
  }

  String? getRoomId() {
    return _roomIdentifier;
  }
}
