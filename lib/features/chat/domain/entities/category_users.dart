import 'package:messaging_core/core/enums/user_roles.dart';
import 'package:messaging_core/features/chat/domain/entities/chats_parent_model.dart';

class CategoryUser extends ChatParentClass {
  CategoryUser({
    int? id,
    String? name,
    String? username,
    String? avatar,
    int? creatorUserId,
    int? categoryId,
    int? level,
    String? status,
    String? email,
    String? statusEmail,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<UserRoles>? roles,
  }) : super(
          id: id,
          name: name,
          username: username,
          avatar: avatar,
          categoryId: categoryId,
          level: level,
          createdAt: createdAt,
          updatedAt: updatedAt,
          creatorUserId: creatorUserId,
          roles: roles,
        );

  static CategoryUser fromJson(Map<String, dynamic> json) {
    return CategoryUser(
        id: json['id'],
        name: json['name'],
        username: json['username'],
        avatar: json['avatar'],
        level: json['level'],
        status: json['status'],
        email: json['email'],
        statusEmail: json['status_email'],
        roles: UserRoles.fromList(json['roles']));
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['username'] = username;
    data['avatar'] = avatar;
    data['level'] = level;
    data['status'] = status;
    data['email'] = email;
    data['status_email'] = statusEmail;
    data['roles'] = roles;
    return data;
  }

  static List<CategoryUser> listFromJson(dynamic json) {
    if (json != null) {
      return json.map<CategoryUser>((j) {
        return CategoryUser.fromJson(j);
      }).toList();
    }
    return [];
  }
}
