import 'package:api_handler/api_handler.dart';
import 'package:api_handler/feature/api_handler/data/models/response_model.dart';
import 'package:get/get.dart';
import 'package:messaging_core/core/app_states/result_state.dart';
import 'package:messaging_core/core/enums/receiver_type.dart';
import 'package:messaging_core/features/chat/data/models/users_groups_category.dart';
import 'package:messaging_core/features/chat/domain/entities/chats_parent_model.dart';
import 'package:messaging_core/features/chat/domain/entities/content_model.dart';
import 'package:messaging_core/features/chat/domain/use_cases/get_all_chats_use_case.dart';
import 'package:messaging_core/features/chat/domain/use_cases/get_messages_use_case.dart';

class ChatController extends GetxController {
  final GetAllChatsUseCase getAllChatsUseCase;
  final GetMessagesUseCase getMessagesUseCase;

  ChatController(this.getAllChatsUseCase, this.getMessagesUseCase);

  RequestStatus chatsStatus = RequestStatus();
  RequestStatus messagesStatus = RequestStatus();

  List<ChatParentClass> chats = [];
  List<ContentModel> messages = [];


  getAllChats() async {
    try {
      chatsStatus.loading();
      update(["allChats"]);

      ResponseModel response = await getAllChatsUseCase(null);
      if (response.result == ResultEnum.success) {
        UsersAndGroupsInCategory usersAndGroupsInCategory = response.data;

        chats.addAll(usersAndGroupsInCategory.users);
        chats.addAll(usersAndGroupsInCategory.groups);

        chatsStatus.success();
        update(["allChats"]);
      }
    } catch (e) {
      chatsStatus.error(e.toString());
      update(["allChats"]);
    }
  }

  getMessages(ReceiverType receiverType, int receiverId, int senderId) async {
    try {
      messagesStatus.loading();
      update(["messages"]);

      ResponseModel response = await getMessagesUseCase(GetMessagesParams(
          receiverType: receiverType,
          receiverId: receiverId,
          senderId: senderId));
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


}
