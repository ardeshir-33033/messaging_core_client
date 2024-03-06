import 'package:messaging_core/core/enums/content_type_enum.dart';
import 'package:messaging_core/core/enums/receiver_type.dart';
import 'package:messaging_core/features/chat/domain/entities/chats_parent_model.dart';
import 'package:messaging_core/features/chat/domain/entities/content_model.dart';
import 'package:messaging_core/features/chat/domain/entities/group_users_model.dart';

class GroupModel extends ChatParentClass {
  GroupModel({
    int? id,
    String? name,
    String? username,
    String? avatar,
    int? creatorUserId,
    int? categoryId,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? unreadCount,
    ContentModel? lastRead,
    ContentModel? lastMessage,
    List<GroupUsersModel> groupUsers = const [],
  }) : super(
          id: id,
          name: name,
          username: username,
          avatar: avatar,
          categoryId: categoryId,
          createdAt: createdAt,
          updatedAt: updatedAt,
          creatorUserId: creatorUserId,
          unreadCount: unreadCount,
          lastRead: lastRead,
          groupUsers: groupUsers,
          lastMessage: lastMessage,
        );

  static GroupModel fromJson(Map<String, dynamic> json) {
    return GroupModel(
        id: json['id'],
        name: json['name'],
        avatar: json['avatar'],
        creatorUserId: json['creator_user_id'].runtimeType == int
            ? json['creator_user_id']
            : int.parse(json['creator_user_id']),
        categoryId: json['category_id'].runtimeType == int
            ? json['category_id']
            : int.parse(json['category_id']),
        unreadCount: json['unreadCount'],
        lastMessage: json["lastMessage"] != null
            ? ContentModel.fromJson(json["lastMessage"])
            : null,
        groupUsers: json['users'] != null
            ? GroupUsersModel.listFromJson(json['users'])
            : [],
        lastRead: json["lastRead"] != null
            ? ContentModel.fromJson(json["lastRead"])
            : null,
        createdAt: DateTime.parse(json['created_at']),
        updatedAt: DateTime.parse(json['updated_at']));
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['avatar'] = avatar;
    data['creator_user_id'] = creatorUserId;
    data['category_id'] = categoryId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['unreadCount'] = unreadCount;
    data['lastRead'] = lastRead;
    return data;
  }

  static List<GroupModel> listFromJson(dynamic json) {
    if (json != null) {
      return json.map<GroupModel>((j) {
        return GroupModel.fromJson(j);
      }).toList();
    }
    return [];
  }
}
