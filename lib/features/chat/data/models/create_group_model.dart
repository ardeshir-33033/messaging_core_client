import 'package:messaging_core/features/chat/domain/entities/group_model.dart';
import 'package:messaging_core/features/chat/domain/entities/group_users_model.dart';

class CreateGroupModel {
  GroupModel group;
  List<GroupUsersModel> groupUsers = const [];

  CreateGroupModel({required this.group, required this.groupUsers});

  static CreateGroupModel fromJson(Map<String, dynamic> json) {
    return CreateGroupModel(
      group: GroupModel.fromJson(json['chatGroup']),
      groupUsers: GroupUsersModel.listFromJson(json['usersInGroup']),
    );
  }
}
