import 'package:drift/drift.dart';
import 'package:messaging_core/core/app_states/app_global_data.dart';
import 'package:messaging_core/core/enums/receiver_type.dart';
import 'package:messaging_core/core/enums/user_roles.dart';
import 'package:messaging_core/core/storage/database.dart';
import 'package:messaging_core/features/chat/domain/entities/content_model.dart';
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
  ContentModel? lastRead;
  ContentModel? lastMessage;
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
    this.lastMessage,
    this.groupUsers = const [],
  });

  factory ChatParentClass.fromChatTable(ChatsTableData chat) => ChatParentClass(
      id: chat.id,
      name: chat.name,
      createdAt: chat.createdAt,
      updatedAt: chat.updatedAt,
      avatar: chat.avatar,
      categoryId: chat.categoryId,
      creatorUserId: chat.creatorUserId,
      status: chat.status,
      level: chat.level);

  ChatsTableCompanion toChatTableData() => ChatsTableCompanion(
      id: Value(id!),
      name: Value(name!),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      avatar: Value(avatar),
      categoryId: Value(categoryId ?? AppGlobalData.categoryId),
      creatorUserId: Value(creatorUserId!),
      status: Value(status),
      level: Value(level ?? 1));

  bool isGroup() => creatorUserId != null;

  ReceiverType getReceiverType() =>
      isGroup() ? ReceiverType.group : ReceiverType.user;
}
