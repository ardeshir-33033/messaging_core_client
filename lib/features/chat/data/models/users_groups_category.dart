import 'package:messaging_core/features/chat/domain/entities/category_users.dart';
import 'package:messaging_core/features/chat/domain/entities/group_model.dart';

class UsersAndGroupsInCategory {
  List<CategoryUser> users;
  List<GroupModel> groups;

  UsersAndGroupsInCategory({this.users = const [], this.groups = const []});

  static UsersAndGroupsInCategory fromJson(Map<String, dynamic> json) {
    return UsersAndGroupsInCategory(
      users: CategoryUser.listFromJson(json['usersInCategory']),
      groups: GroupModel.listFromJson(json['myGroupsInCategory']),
    );
  }
}
