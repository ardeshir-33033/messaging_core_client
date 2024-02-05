import 'package:api_handler/api_handler.dart';
import 'package:api_handler/feature/api_handler/data/models/response_model.dart';
import 'package:get/get.dart';
import 'package:messaging_core/core/app_states/result_state.dart';
import 'package:messaging_core/features/chat/data/models/users_groups_category.dart';
import 'package:messaging_core/features/chat/domain/entities/chats_parent_model.dart';
import 'package:messaging_core/features/chat/domain/use_cases/get_all_chats_use_case.dart';

class ChatController extends GetxController {
  final GetAllChatsUseCase getAllChatsUseCase;

  ChatController(this.getAllChatsUseCase);

  RequestStatus chatsStatus = RequestStatus();

  UsersAndGroupsInCategory usersAndGroupsInCategory =
      UsersAndGroupsInCategory();

  List<ChatParentClass> chats = [];

  getAllChats() async {
    try {
      chatsStatus.loading();
      update(["allChats"]);

      ResponseModel response = await getAllChatsUseCase(null);
      if (response.result == ResultEnum.success) {
        usersAndGroupsInCategory = response.data;

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
}
