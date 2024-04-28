import 'dart:convert';

import 'package:messaging_core/core/enums/receiver_type.dart';
import 'package:messaging_core/core/enums/user_roles.dart';
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

  // factory ChatParentClass.fromChatTable(ChatsTableData chat) {
  //   return ChatParentClass(
  //       id: chat.id,
  //       name: chat.name,
  //       createdAt: chat.createdAt,
  //       updatedAt: chat.updatedAt,
  //       avatar: chat.avatar,
  //       categoryId: chat.categoryId,
  //       creatorUserId: chat.creatorUserId,
  //       groupUsers: chat.groupUsers != null
  //           ? GroupUsersModel.listFromJson(jsonDecode(chat.groupUsers!))
  //           : null,
  //       lastMessage: chat.lastMessage != null
  //           ? ContentModel.fromJson(jsonDecode(chat.lastMessage!))
  //           : null,
  //       lastRead: chat.lastRead != null
  //           ? ContentModel.fromJson(jsonDecode(chat.lastRead!))
  //           : null,
  //       status: chat.status,
  //       level: chat.level);
  // }

  // ChatsTableData toChatTableData() => ChatsTableData(
  //     id: id!,
  //     name: (name!),
  //     createdAt: (createdAt),
  //     updatedAt: (updatedAt),
  //     avatar: (avatar),
  //     categoryId: (categoryId ?? AppGlobalData.categoryId),
  //     creatorUserId: (creatorUserId),
  //     groupUsers: groupUsers != null
  //         ? jsonEncode(
  //             groupUsers!.map((groupUser) => groupUser.toJson()).toList())
  //         : null,
  //     lastMessage:
  //         lastMessage != null ? jsonEncode(lastMessage!.toJson()) : null,
  //     lastRead: lastRead != null ? jsonEncode(lastRead!.toJson()) : null,
  //     status: (status),
  //     level: (level ?? 1));

  bool isGroup() => creatorUserId != null;

  ReceiverType getReceiverType() =>
      isGroup() ? ReceiverType.group : ReceiverType.user;
}
