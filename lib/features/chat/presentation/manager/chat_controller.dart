import 'dart:io';

import 'package:api_handler/api_handler.dart';
import 'package:api_handler/feature/api_handler/data/models/response_model.dart';
import 'package:get/get.dart';
import 'package:messaging_core/app/theme/constants.dart';
import 'package:messaging_core/core/app_states/app_global_data.dart';
import 'package:messaging_core/core/app_states/result_state.dart';
import 'package:messaging_core/core/enums/content_type_enum.dart';
import 'package:messaging_core/core/enums/message_status.dart';
import 'package:messaging_core/core/enums/receiver_type.dart';
import 'package:messaging_core/core/services/media_handler/file_model.dart';
import 'package:messaging_core/core/services/network/websocket/messaging_client.dart';
import 'package:messaging_core/core/utils/utils.dart';
import 'package:messaging_core/features/chat/data/models/create_group_model.dart';
import 'package:messaging_core/features/chat/data/models/users_groups_category.dart';
import 'package:messaging_core/features/chat/domain/entities/category_users.dart';
import 'package:messaging_core/features/chat/domain/entities/chats_parent_model.dart';
import 'package:messaging_core/features/chat/domain/entities/content_model.dart';
import 'package:messaging_core/features/chat/domain/entities/content_payload_model.dart';
import 'package:messaging_core/features/chat/domain/repositories/storage/chat_storage_repository.dart';
import 'package:messaging_core/features/chat/domain/use_cases/create_group_use_case.dart';
import 'package:messaging_core/features/chat/domain/use_cases/edit_message_use_case.dart';
import 'package:messaging_core/features/chat/domain/use_cases/get_all_chats_use_case.dart';
import 'package:messaging_core/features/chat/domain/use_cases/get_messages_use_case.dart';
import 'package:messaging_core/features/chat/domain/use_cases/send_messags_use_case.dart';
import 'package:messaging_core/features/chat/presentation/manager/emoji_controller.dart';
import 'package:messaging_core/features/chat/presentation/manager/record_voice_controller.dart';
import 'package:messaging_core/locator.dart';

class ChatController extends GetxController {
  final GetAllChatsUseCase getAllChatsUseCase;
  final GetMessagesUseCase getMessagesUseCase;
  final SendMessagesUseCase sendMessageUsecase;
  final EditMessagesUseCase editMessagesUseCase;
  final CreateGroupUseCase createGroupUseCase;
  final ChatStorageRepository chatStorageRepository;
  final MessagingClient messagingClient;

  ChatController(
      this.getAllChatsUseCase,
      this.getMessagesUseCase,
      this.sendMessageUsecase,
      this.messagingClient,
      this.editMessagesUseCase,
      this.chatStorageRepository,
      this.createGroupUseCase);

  RequestStatus chatsStatus = RequestStatus();
  RequestStatus messagesStatus = RequestStatus();

  List<ChatParentClass> chats = [];
  List<ContentModel> messages = [];
  List<CategoryUser> users = [];
  bool isTyping = false;
  ContentModel? editingContent;
  late ChatParentClass? _currentChat;
  late String? _roomIdentifier;

  void setCurrentChat(ChatParentClass value) {
    _currentChat = value;
  }

  resetState() {
    messages = [];
    users = [];
    _currentChat = null;
    _roomIdentifier = null;
    isTyping = false;
    editingContent = null;
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
        UsersAndGroupsInCategory usersAndGroupsInCategory = response.data;

        users.addAll(usersAndGroupsInCategory.users);

        chats.addAll(usersAndGroupsInCategory.users);
        chats.addAll(usersAndGroupsInCategory.groups);

        chats.sort((a, b) => ((b.updatedAt ?? b.lastMessage?.updatedAt) ??
                DateTime(1998))
            .compareTo(
                ((a.updatedAt ?? a.lastMessage?.updatedAt) ?? DateTime(1998))));
        addStarChat();

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

      ResponseModel response = await getMessagesUseCase(GetMessagesParams(
        receiverType: _currentChat!.getReceiverType(),
        receiverId: _currentChat!.id!,
        senderId: _currentChat!.isGroup() ? null : AppGlobalData.userId,
      ));
      if (response.result == ResultEnum.success) {
        messages = response.data;
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
          receiverType: _currentChat!.getReceiverType(),
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          contentType: contentType ?? ContentTypeEnum.text,
          contentPayload: contentPayload,
          messageText: text,
          filePath: file?.filePath,
          categoryId: AppGlobalData.categoryId,
          receiverId: receiverId,
          status: MessageStatus.sending);
      messages.insert(0, content);
      update(["messages"]);

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

  editTextMessage(String newMessage, int messageId, messageIndex) async {
    try {
      messages[messageIndex].messageText = newMessage;

      ResponseModel response = await editMessagesUseCase(
          EditMessagesParams(newMessage: newMessage, messageId: messageId));

      if (response.result != ResultEnum.success) {
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
    if (_currentChat!.isGroup()) {
      List<int> groupIds = _currentChat!.groupUsers!.map((e) => e.id).toList();
      groupIds.sort();
      String result = groupIds.join();
      _roomIdentifier = "${_currentChat!.id}$result";
    } else {
      List<int> ids = [
        AppGlobalData.userId,
        _currentChat!.id!,
        AppGlobalData.categoryId
      ];
      // ids.add(AppGlobalData.userId);
      // ids.add(_currentChat!.id!);
      ids.sort();
      _roomIdentifier = ids.join('-');

      // [AppGlobalData.userId, _currentChat!.id, AppGlobalData.categoryId].sort();
      // _roomIdentifier = ids.join();
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

  addStarChat() {
    chats.add(ChatParentClass(
      id: AppGlobalData.userId,
      name: "Starred Chat",
    ));
  }

  handleReceivedMessages(Map<String, dynamic> json, String roomIdentifier) {
    ContentModel content = ContentModel.fromSocketJson(json);
    if (_currentChat != null) {
      if (_roomIdentifier == roomIdentifier) {
        messages.insert(0, content);
        update(["messages"]);
      }
    }
  }

  handleNotificationSignal(int chatId, ReceiverType receiverType) {
    chats.forEach((element) {
      if (element.id == chatId) {
        element.unreadCount = element.unreadCount ?? 0 + 1;
        chats.remove(element);
        chats.insert(0, element);
        locator<RecordVoiceController>()
            .playSimpleAudio(Assets.notificationTone);
        update(["allChats"]);
      }
    });
  }

  handleUserTypingSignal(int senderId) {
    if (_currentChat?.id == senderId) {
      isTyping = true;
      update(["isTyping"]);
    }
  }

  handleUserStoppedTypingSignal(int senderId) {
    if (_currentChat?.id == senderId) {
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

  getMessagesTable() async {
    List<ContentModel> messages =
        await chatStorageRepository.getMessages(_roomIdentifier!);
    print(messages);
  }

  saveMessages() async {
    print(messages);
    await chatStorageRepository.saveMessages(messages, _roomIdentifier!);
    print("nice");
  }
}
