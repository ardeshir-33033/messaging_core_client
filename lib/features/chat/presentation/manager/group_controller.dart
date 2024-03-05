import 'package:api_handler/api_handler.dart';
import 'package:api_handler/feature/api_handler/data/models/response_model.dart';
import 'package:get/get.dart';
import 'package:messaging_core/core/app_states/result_state.dart';
import 'package:messaging_core/core/services/media_handler/file_model.dart';
import 'package:messaging_core/features/chat/data/models/create_group_model.dart';
import 'package:messaging_core/features/chat/domain/use_cases/group/edit_group_use_case.dart';
import 'package:messaging_core/features/chat/presentation/manager/chat_controller.dart';
import 'package:messaging_core/locator.dart';

class GroupController extends GetxController {
  final EditGroupUseCase editGroupUseCase;

  RequestStatus getContactsStatus = RequestStatus();

  GroupController(this.editGroupUseCase);

  Future editGroup(String groupName, List<int> users, int groupId,
      {FileModel? file}) async {
    getContactsStatus.loading();
    update(["edit"]);

    ResponseModel response = await editGroupUseCase(
        EditGroupParams(groupName: groupName, users: users, groupId: groupId));

    if (response.result == ResultEnum.success) {
      final ChatController controller = locator<ChatController>();

      getContactsStatus.success();
      update(["edit"]);

      int index = controller.chats.indexWhere(
        (element) => element.id == groupId,
      );

      if (index != -1) {
        CreateGroupModel groupModel = response.data;
        controller.chats[index]
          ..groupUsers = groupModel.groupUsers
          ..name = groupModel.group.name
          ..avatar = groupModel.group.avatar;
      }
    }
  }
}
