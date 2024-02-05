import 'package:messaging_core/core/enums/user_roles.dart';

class CategoryUser {
  int id;
  String name;
  String username;
  dynamic avatar;
  int level;
  String status;
  String email;
  String statusEmail;
  List<UserRoles> roles;

  CategoryUser({
    required this.id,
    required this.name,
    required this.username,
    required this.avatar,
    required this.level,
    required this.status,
    required this.email,
    required this.statusEmail,
    required this.roles,
  });

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
