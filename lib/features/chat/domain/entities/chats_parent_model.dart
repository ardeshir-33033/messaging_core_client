import 'package:messaging_core/core/enums/receiver_type.dart';
import 'package:messaging_core/core/enums/user_roles.dart';
import 'package:messaging_core/features/chat/domain/entities/group_users_model.dart';

class ChatParentClass {
  int? id;
  String? name;
  String? avatar;
  int? creatorUserId;
  int? categoryId;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? unreadCount;
  List<GroupUsersModel>? groupUsers;
  dynamic lastRead;
  String? username;
  int? level;
  String? status;
  String? email;
  String? statusEmail;
  List<UserRoles>? roles;

  ChatParentClass({
    this.id,
    this.name,
    this.username,
    this.avatar,
    this.level,
    this.status,
    this.email,
    this.statusEmail,
    this.roles,
    this.creatorUserId,
    this.categoryId,
    this.createdAt,
    this.updatedAt,
    this.unreadCount,
    this.lastRead,
    this.groupUsers = const [],
  });

  bool isGroup() => unreadCount != null;

  ReceiverType getReceiverType() =>
      isGroup() ? ReceiverType.group : ReceiverType.user;
}
