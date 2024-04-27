// // GENERATED CODE - DO NOT MODIFY BY HAND
//
// part of 'database.dart';
//
// // ignore_for_file: type=lint
// class $ChatsTableTable extends ChatsTable
//     with TableInfo<$ChatsTableTable, ChatsTableData> {
//   @override
//   final GeneratedDatabase attachedDatabase;
//   final String? _alias;
//   $ChatsTableTable(this.attachedDatabase, [this._alias]);
//   static const VerificationMeta _idMeta = const VerificationMeta('id');
//   @override
//   late final GeneratedColumn<int> id = GeneratedColumn<int>(
//       'id', aliasedName, false,
//       type: DriftSqlType.int, requiredDuringInsert: false);
//   static const VerificationMeta _creatorUserIdMeta =
//       const VerificationMeta('creatorUserId');
//   @override
//   late final GeneratedColumn<int> creatorUserId = GeneratedColumn<int>(
//       'creator_user_id', aliasedName, true,
//       type: DriftSqlType.int, requiredDuringInsert: false);
//   static const VerificationMeta _categoryIdMeta =
//       const VerificationMeta('categoryId');
//   @override
//   late final GeneratedColumn<int> categoryId = GeneratedColumn<int>(
//       'category_id', aliasedName, false,
//       type: DriftSqlType.int, requiredDuringInsert: true);
//   static const VerificationMeta _levelMeta = const VerificationMeta('level');
//   @override
//   late final GeneratedColumn<int> level = GeneratedColumn<int>(
//       'level', aliasedName, true,
//       type: DriftSqlType.int, requiredDuringInsert: false);
//   static const VerificationMeta _nameMeta = const VerificationMeta('name');
//   @override
//   late final GeneratedColumn<String> name = GeneratedColumn<String>(
//       'name', aliasedName, true,
//       type: DriftSqlType.string, requiredDuringInsert: false);
//   static const VerificationMeta _avatarMeta = const VerificationMeta('avatar');
//   @override
//   late final GeneratedColumn<String> avatar = GeneratedColumn<String>(
//       'avatar', aliasedName, true,
//       type: DriftSqlType.string, requiredDuringInsert: false);
//   static const VerificationMeta _usernameMeta =
//       const VerificationMeta('username');
//   @override
//   late final GeneratedColumn<String> username = GeneratedColumn<String>(
//       'username', aliasedName, true,
//       type: DriftSqlType.string, requiredDuringInsert: false);
//   static const VerificationMeta _statusMeta = const VerificationMeta('status');
//   @override
//   late final GeneratedColumn<String> status = GeneratedColumn<String>(
//       'status', aliasedName, true,
//       type: DriftSqlType.string, requiredDuringInsert: false);
//   static const VerificationMeta _groupUsersMeta =
//       const VerificationMeta('groupUsers');
//   @override
//   late final GeneratedColumn<String> groupUsers = GeneratedColumn<String>(
//       'group_users', aliasedName, true,
//       type: DriftSqlType.string, requiredDuringInsert: false);
//   static const VerificationMeta _lastMessageMeta =
//       const VerificationMeta('lastMessage');
//   @override
//   late final GeneratedColumn<String> lastMessage = GeneratedColumn<String>(
//       'last_message', aliasedName, true,
//       type: DriftSqlType.string, requiredDuringInsert: false);
//   static const VerificationMeta _lastReadMeta =
//       const VerificationMeta('lastRead');
//   @override
//   late final GeneratedColumn<String> lastRead = GeneratedColumn<String>(
//       'last_read', aliasedName, true,
//       type: DriftSqlType.string, requiredDuringInsert: false);
//   static const VerificationMeta _createdAtMeta =
//       const VerificationMeta('createdAt');
//   @override
//   late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
//       'created_at', aliasedName, true,
//       type: DriftSqlType.dateTime, requiredDuringInsert: false);
//   static const VerificationMeta _updatedAtMeta =
//       const VerificationMeta('updatedAt');
//   @override
//   late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
//       'updated_at', aliasedName, true,
//       type: DriftSqlType.dateTime, requiredDuringInsert: false);
//   @override
//   List<GeneratedColumn> get $columns => [
//         id,
//         creatorUserId,
//         categoryId,
//         level,
//         name,
//         avatar,
//         username,
//         status,
//         groupUsers,
//         lastMessage,
//         lastRead,
//         createdAt,
//         updatedAt
//       ];
//   @override
//   String get aliasedName => _alias ?? actualTableName;
//   @override
//   String get actualTableName => $name;
//   static const String $name = 'chats_table';
//   @override
//   VerificationContext validateIntegrity(Insertable<ChatsTableData> instance,
//       {bool isInserting = false}) {
//     final context = VerificationContext();
//     final data = instance.toColumns(true);
//     if (data.containsKey('id')) {
//       context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
//     }
//     if (data.containsKey('creator_user_id')) {
//       context.handle(
//           _creatorUserIdMeta,
//           creatorUserId.isAcceptableOrUnknown(
//               data['creator_user_id']!, _creatorUserIdMeta));
//     }
//     if (data.containsKey('category_id')) {
//       context.handle(
//           _categoryIdMeta,
//           categoryId.isAcceptableOrUnknown(
//               data['category_id']!, _categoryIdMeta));
//     } else if (isInserting) {
//       context.missing(_categoryIdMeta);
//     }
//     if (data.containsKey('level')) {
//       context.handle(
//           _levelMeta, level.isAcceptableOrUnknown(data['level']!, _levelMeta));
//     }
//     if (data.containsKey('name')) {
//       context.handle(
//           _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
//     }
//     if (data.containsKey('avatar')) {
//       context.handle(_avatarMeta,
//           avatar.isAcceptableOrUnknown(data['avatar']!, _avatarMeta));
//     }
//     if (data.containsKey('username')) {
//       context.handle(_usernameMeta,
//           username.isAcceptableOrUnknown(data['username']!, _usernameMeta));
//     }
//     if (data.containsKey('status')) {
//       context.handle(_statusMeta,
//           status.isAcceptableOrUnknown(data['status']!, _statusMeta));
//     }
//     if (data.containsKey('group_users')) {
//       context.handle(
//           _groupUsersMeta,
//           groupUsers.isAcceptableOrUnknown(
//               data['group_users']!, _groupUsersMeta));
//     }
//     if (data.containsKey('last_message')) {
//       context.handle(
//           _lastMessageMeta,
//           lastMessage.isAcceptableOrUnknown(
//               data['last_message']!, _lastMessageMeta));
//     }
//     if (data.containsKey('last_read')) {
//       context.handle(_lastReadMeta,
//           lastRead.isAcceptableOrUnknown(data['last_read']!, _lastReadMeta));
//     }
//     if (data.containsKey('created_at')) {
//       context.handle(_createdAtMeta,
//           createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
//     }
//     if (data.containsKey('updated_at')) {
//       context.handle(_updatedAtMeta,
//           updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
//     }
//     return context;
//   }
//
//   @override
//   Set<GeneratedColumn> get $primaryKey => {id};
//   @override
//   ChatsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
//     final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
//     return ChatsTableData(
//       id: attachedDatabase.typeMapping
//           .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
//       creatorUserId: attachedDatabase.typeMapping
//           .read(DriftSqlType.int, data['${effectivePrefix}creator_user_id']),
//       categoryId: attachedDatabase.typeMapping
//           .read(DriftSqlType.int, data['${effectivePrefix}category_id'])!,
//       level: attachedDatabase.typeMapping
//           .read(DriftSqlType.int, data['${effectivePrefix}level']),
//       name: attachedDatabase.typeMapping
//           .read(DriftSqlType.string, data['${effectivePrefix}name']),
//       avatar: attachedDatabase.typeMapping
//           .read(DriftSqlType.string, data['${effectivePrefix}avatar']),
//       username: attachedDatabase.typeMapping
//           .read(DriftSqlType.string, data['${effectivePrefix}username']),
//       status: attachedDatabase.typeMapping
//           .read(DriftSqlType.string, data['${effectivePrefix}status']),
//       groupUsers: attachedDatabase.typeMapping
//           .read(DriftSqlType.string, data['${effectivePrefix}group_users']),
//       lastMessage: attachedDatabase.typeMapping
//           .read(DriftSqlType.string, data['${effectivePrefix}last_message']),
//       lastRead: attachedDatabase.typeMapping
//           .read(DriftSqlType.string, data['${effectivePrefix}last_read']),
//       createdAt: attachedDatabase.typeMapping
//           .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at']),
//       updatedAt: attachedDatabase.typeMapping
//           .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at']),
//     );
//   }
//
//   @override
//   $ChatsTableTable createAlias(String alias) {
//     return $ChatsTableTable(attachedDatabase, alias);
//   }
// }
//
// class ChatsTableData extends DataClass implements Insertable<ChatsTableData> {
//   final int id;
//   final int? creatorUserId;
//   final int categoryId;
//   final int? level;
//   final String? name;
//   final String? avatar;
//   final String? username;
//   final String? status;
//   final String? groupUsers;
//   final String? lastMessage;
//   final String? lastRead;
//   final DateTime? createdAt;
//   final DateTime? updatedAt;
//   const ChatsTableData(
//       {required this.id,
//       this.creatorUserId,
//       required this.categoryId,
//       this.level,
//       this.name,
//       this.avatar,
//       this.username,
//       this.status,
//       this.groupUsers,
//       this.lastMessage,
//       this.lastRead,
//       this.createdAt,
//       this.updatedAt});
//   @override
//   Map<String, Expression> toColumns(bool nullToAbsent) {
//     final map = <String, Expression>{};
//     map['id'] = Variable<int>(id);
//     if (!nullToAbsent || creatorUserId != null) {
//       map['creator_user_id'] = Variable<int>(creatorUserId);
//     }
//     map['category_id'] = Variable<int>(categoryId);
//     if (!nullToAbsent || level != null) {
//       map['level'] = Variable<int>(level);
//     }
//     if (!nullToAbsent || name != null) {
//       map['name'] = Variable<String>(name);
//     }
//     if (!nullToAbsent || avatar != null) {
//       map['avatar'] = Variable<String>(avatar);
//     }
//     if (!nullToAbsent || username != null) {
//       map['username'] = Variable<String>(username);
//     }
//     if (!nullToAbsent || status != null) {
//       map['status'] = Variable<String>(status);
//     }
//     if (!nullToAbsent || groupUsers != null) {
//       map['group_users'] = Variable<String>(groupUsers);
//     }
//     if (!nullToAbsent || lastMessage != null) {
//       map['last_message'] = Variable<String>(lastMessage);
//     }
//     if (!nullToAbsent || lastRead != null) {
//       map['last_read'] = Variable<String>(lastRead);
//     }
//     if (!nullToAbsent || createdAt != null) {
//       map['created_at'] = Variable<DateTime>(createdAt);
//     }
//     if (!nullToAbsent || updatedAt != null) {
//       map['updated_at'] = Variable<DateTime>(updatedAt);
//     }
//     return map;
//   }
//
//   ChatsTableCompanion toCompanion(bool nullToAbsent) {
//     return ChatsTableCompanion(
//       id: Value(id),
//       creatorUserId: creatorUserId == null && nullToAbsent
//           ? const Value.absent()
//           : Value(creatorUserId),
//       categoryId: Value(categoryId),
//       level:
//           level == null && nullToAbsent ? const Value.absent() : Value(level),
//       name: name == null && nullToAbsent ? const Value.absent() : Value(name),
//       avatar:
//           avatar == null && nullToAbsent ? const Value.absent() : Value(avatar),
//       username: username == null && nullToAbsent
//           ? const Value.absent()
//           : Value(username),
//       status:
//           status == null && nullToAbsent ? const Value.absent() : Value(status),
//       groupUsers: groupUsers == null && nullToAbsent
//           ? const Value.absent()
//           : Value(groupUsers),
//       lastMessage: lastMessage == null && nullToAbsent
//           ? const Value.absent()
//           : Value(lastMessage),
//       lastRead: lastRead == null && nullToAbsent
//           ? const Value.absent()
//           : Value(lastRead),
//       createdAt: createdAt == null && nullToAbsent
//           ? const Value.absent()
//           : Value(createdAt),
//       updatedAt: updatedAt == null && nullToAbsent
//           ? const Value.absent()
//           : Value(updatedAt),
//     );
//   }
//
//   factory ChatsTableData.fromJson(Map<String, dynamic> json,
//       {ValueSerializer? serializer}) {
//     serializer ??= driftRuntimeOptions.defaultSerializer;
//     return ChatsTableData(
//       id: serializer.fromJson<int>(json['id']),
//       creatorUserId: serializer.fromJson<int?>(json['creatorUserId']),
//       categoryId: serializer.fromJson<int>(json['categoryId']),
//       level: serializer.fromJson<int?>(json['level']),
//       name: serializer.fromJson<String?>(json['name']),
//       avatar: serializer.fromJson<String?>(json['avatar']),
//       username: serializer.fromJson<String?>(json['username']),
//       status: serializer.fromJson<String?>(json['status']),
//       groupUsers: serializer.fromJson<String?>(json['groupUsers']),
//       lastMessage: serializer.fromJson<String?>(json['lastMessage']),
//       lastRead: serializer.fromJson<String?>(json['lastRead']),
//       createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
//       updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
//     );
//   }
//   @override
//   Map<String, dynamic> toJson({ValueSerializer? serializer}) {
//     serializer ??= driftRuntimeOptions.defaultSerializer;
//     return <String, dynamic>{
//       'id': serializer.toJson<int>(id),
//       'creatorUserId': serializer.toJson<int?>(creatorUserId),
//       'categoryId': serializer.toJson<int>(categoryId),
//       'level': serializer.toJson<int?>(level),
//       'name': serializer.toJson<String?>(name),
//       'avatar': serializer.toJson<String?>(avatar),
//       'username': serializer.toJson<String?>(username),
//       'status': serializer.toJson<String?>(status),
//       'groupUsers': serializer.toJson<String?>(groupUsers),
//       'lastMessage': serializer.toJson<String?>(lastMessage),
//       'lastRead': serializer.toJson<String?>(lastRead),
//       'createdAt': serializer.toJson<DateTime?>(createdAt),
//       'updatedAt': serializer.toJson<DateTime?>(updatedAt),
//     };
//   }
//
//   ChatsTableData copyWith(
//           {int? id,
//           Value<int?> creatorUserId = const Value.absent(),
//           int? categoryId,
//           Value<int?> level = const Value.absent(),
//           Value<String?> name = const Value.absent(),
//           Value<String?> avatar = const Value.absent(),
//           Value<String?> username = const Value.absent(),
//           Value<String?> status = const Value.absent(),
//           Value<String?> groupUsers = const Value.absent(),
//           Value<String?> lastMessage = const Value.absent(),
//           Value<String?> lastRead = const Value.absent(),
//           Value<DateTime?> createdAt = const Value.absent(),
//           Value<DateTime?> updatedAt = const Value.absent()}) =>
//       ChatsTableData(
//         id: id ?? this.id,
//         creatorUserId:
//             creatorUserId.present ? creatorUserId.value : this.creatorUserId,
//         categoryId: categoryId ?? this.categoryId,
//         level: level.present ? level.value : this.level,
//         name: name.present ? name.value : this.name,
//         avatar: avatar.present ? avatar.value : this.avatar,
//         username: username.present ? username.value : this.username,
//         status: status.present ? status.value : this.status,
//         groupUsers: groupUsers.present ? groupUsers.value : this.groupUsers,
//         lastMessage: lastMessage.present ? lastMessage.value : this.lastMessage,
//         lastRead: lastRead.present ? lastRead.value : this.lastRead,
//         createdAt: createdAt.present ? createdAt.value : this.createdAt,
//         updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
//       );
//   @override
//   String toString() {
//     return (StringBuffer('ChatsTableData(')
//           ..write('id: $id, ')
//           ..write('creatorUserId: $creatorUserId, ')
//           ..write('categoryId: $categoryId, ')
//           ..write('level: $level, ')
//           ..write('name: $name, ')
//           ..write('avatar: $avatar, ')
//           ..write('username: $username, ')
//           ..write('status: $status, ')
//           ..write('groupUsers: $groupUsers, ')
//           ..write('lastMessage: $lastMessage, ')
//           ..write('lastRead: $lastRead, ')
//           ..write('createdAt: $createdAt, ')
//           ..write('updatedAt: $updatedAt')
//           ..write(')'))
//         .toString();
//   }
//
//   @override
//   int get hashCode => Object.hash(
//       id,
//       creatorUserId,
//       categoryId,
//       level,
//       name,
//       avatar,
//       username,
//       status,
//       groupUsers,
//       lastMessage,
//       lastRead,
//       createdAt,
//       updatedAt);
//   @override
//   bool operator ==(Object other) =>
//       identical(this, other) ||
//       (other is ChatsTableData &&
//           other.id == this.id &&
//           other.creatorUserId == this.creatorUserId &&
//           other.categoryId == this.categoryId &&
//           other.level == this.level &&
//           other.name == this.name &&
//           other.avatar == this.avatar &&
//           other.username == this.username &&
//           other.status == this.status &&
//           other.groupUsers == this.groupUsers &&
//           other.lastMessage == this.lastMessage &&
//           other.lastRead == this.lastRead &&
//           other.createdAt == this.createdAt &&
//           other.updatedAt == this.updatedAt);
// }
//
// class ChatsTableCompanion extends UpdateCompanion<ChatsTableData> {
//   final Value<int> id;
//   final Value<int?> creatorUserId;
//   final Value<int> categoryId;
//   final Value<int?> level;
//   final Value<String?> name;
//   final Value<String?> avatar;
//   final Value<String?> username;
//   final Value<String?> status;
//   final Value<String?> groupUsers;
//   final Value<String?> lastMessage;
//   final Value<String?> lastRead;
//   final Value<DateTime?> createdAt;
//   final Value<DateTime?> updatedAt;
//   const ChatsTableCompanion({
//     this.id = const Value.absent(),
//     this.creatorUserId = const Value.absent(),
//     this.categoryId = const Value.absent(),
//     this.level = const Value.absent(),
//     this.name = const Value.absent(),
//     this.avatar = const Value.absent(),
//     this.username = const Value.absent(),
//     this.status = const Value.absent(),
//     this.groupUsers = const Value.absent(),
//     this.lastMessage = const Value.absent(),
//     this.lastRead = const Value.absent(),
//     this.createdAt = const Value.absent(),
//     this.updatedAt = const Value.absent(),
//   });
//   ChatsTableCompanion.insert({
//     this.id = const Value.absent(),
//     this.creatorUserId = const Value.absent(),
//     required int categoryId,
//     this.level = const Value.absent(),
//     this.name = const Value.absent(),
//     this.avatar = const Value.absent(),
//     this.username = const Value.absent(),
//     this.status = const Value.absent(),
//     this.groupUsers = const Value.absent(),
//     this.lastMessage = const Value.absent(),
//     this.lastRead = const Value.absent(),
//     this.createdAt = const Value.absent(),
//     this.updatedAt = const Value.absent(),
//   }) : categoryId = Value(categoryId);
//   static Insertable<ChatsTableData> custom({
//     Expression<int>? id,
//     Expression<int>? creatorUserId,
//     Expression<int>? categoryId,
//     Expression<int>? level,
//     Expression<String>? name,
//     Expression<String>? avatar,
//     Expression<String>? username,
//     Expression<String>? status,
//     Expression<String>? groupUsers,
//     Expression<String>? lastMessage,
//     Expression<String>? lastRead,
//     Expression<DateTime>? createdAt,
//     Expression<DateTime>? updatedAt,
//   }) {
//     return RawValuesInsertable({
//       if (id != null) 'id': id,
//       if (creatorUserId != null) 'creator_user_id': creatorUserId,
//       if (categoryId != null) 'category_id': categoryId,
//       if (level != null) 'level': level,
//       if (name != null) 'name': name,
//       if (avatar != null) 'avatar': avatar,
//       if (username != null) 'username': username,
//       if (status != null) 'status': status,
//       if (groupUsers != null) 'group_users': groupUsers,
//       if (lastMessage != null) 'last_message': lastMessage,
//       if (lastRead != null) 'last_read': lastRead,
//       if (createdAt != null) 'created_at': createdAt,
//       if (updatedAt != null) 'updated_at': updatedAt,
//     });
//   }
//
//   ChatsTableCompanion copyWith(
//       {Value<int>? id,
//       Value<int?>? creatorUserId,
//       Value<int>? categoryId,
//       Value<int?>? level,
//       Value<String?>? name,
//       Value<String?>? avatar,
//       Value<String?>? username,
//       Value<String?>? status,
//       Value<String?>? groupUsers,
//       Value<String?>? lastMessage,
//       Value<String?>? lastRead,
//       Value<DateTime?>? createdAt,
//       Value<DateTime?>? updatedAt}) {
//     return ChatsTableCompanion(
//       id: id ?? this.id,
//       creatorUserId: creatorUserId ?? this.creatorUserId,
//       categoryId: categoryId ?? this.categoryId,
//       level: level ?? this.level,
//       name: name ?? this.name,
//       avatar: avatar ?? this.avatar,
//       username: username ?? this.username,
//       status: status ?? this.status,
//       groupUsers: groupUsers ?? this.groupUsers,
//       lastMessage: lastMessage ?? this.lastMessage,
//       lastRead: lastRead ?? this.lastRead,
//       createdAt: createdAt ?? this.createdAt,
//       updatedAt: updatedAt ?? this.updatedAt,
//     );
//   }
//
//   @override
//   Map<String, Expression> toColumns(bool nullToAbsent) {
//     final map = <String, Expression>{};
//     if (id.present) {
//       map['id'] = Variable<int>(id.value);
//     }
//     if (creatorUserId.present) {
//       map['creator_user_id'] = Variable<int>(creatorUserId.value);
//     }
//     if (categoryId.present) {
//       map['category_id'] = Variable<int>(categoryId.value);
//     }
//     if (level.present) {
//       map['level'] = Variable<int>(level.value);
//     }
//     if (name.present) {
//       map['name'] = Variable<String>(name.value);
//     }
//     if (avatar.present) {
//       map['avatar'] = Variable<String>(avatar.value);
//     }
//     if (username.present) {
//       map['username'] = Variable<String>(username.value);
//     }
//     if (status.present) {
//       map['status'] = Variable<String>(status.value);
//     }
//     if (groupUsers.present) {
//       map['group_users'] = Variable<String>(groupUsers.value);
//     }
//     if (lastMessage.present) {
//       map['last_message'] = Variable<String>(lastMessage.value);
//     }
//     if (lastRead.present) {
//       map['last_read'] = Variable<String>(lastRead.value);
//     }
//     if (createdAt.present) {
//       map['created_at'] = Variable<DateTime>(createdAt.value);
//     }
//     if (updatedAt.present) {
//       map['updated_at'] = Variable<DateTime>(updatedAt.value);
//     }
//     return map;
//   }
//
//   @override
//   String toString() {
//     return (StringBuffer('ChatsTableCompanion(')
//           ..write('id: $id, ')
//           ..write('creatorUserId: $creatorUserId, ')
//           ..write('categoryId: $categoryId, ')
//           ..write('level: $level, ')
//           ..write('name: $name, ')
//           ..write('avatar: $avatar, ')
//           ..write('username: $username, ')
//           ..write('status: $status, ')
//           ..write('groupUsers: $groupUsers, ')
//           ..write('lastMessage: $lastMessage, ')
//           ..write('lastRead: $lastRead, ')
//           ..write('createdAt: $createdAt, ')
//           ..write('updatedAt: $updatedAt')
//           ..write(')'))
//         .toString();
//   }
// }
//
// class $MessageTableTable extends MessageTable
//     with TableInfo<$MessageTableTable, MessageTableData> {
//   @override
//   final GeneratedDatabase attachedDatabase;
//   final String? _alias;
//   $MessageTableTable(this.attachedDatabase, [this._alias]);
//   static const VerificationMeta _idMeta = const VerificationMeta('id');
//   @override
//   late final GeneratedColumn<int> id = GeneratedColumn<int>(
//       'id', aliasedName, false,
//       type: DriftSqlType.int, requiredDuringInsert: false);
//   static const VerificationMeta _receiverIdMeta =
//       const VerificationMeta('receiverId');
//   @override
//   late final GeneratedColumn<int> receiverId = GeneratedColumn<int>(
//       'receiver_id', aliasedName, false,
//       type: DriftSqlType.int, requiredDuringInsert: true);
//   static const VerificationMeta _categoryIdMeta =
//       const VerificationMeta('categoryId');
//   @override
//   late final GeneratedColumn<int> categoryId = GeneratedColumn<int>(
//       'category_id', aliasedName, false,
//       type: DriftSqlType.int, requiredDuringInsert: true);
//   static const VerificationMeta _senderIdMeta =
//       const VerificationMeta('senderId');
//   @override
//   late final GeneratedColumn<int> senderId = GeneratedColumn<int>(
//       'sender_id', aliasedName, false,
//       type: DriftSqlType.int, requiredDuringInsert: true);
//   static const VerificationMeta _receiverTypeMeta =
//       const VerificationMeta('receiverType');
//   @override
//   late final GeneratedColumn<String> receiverType = GeneratedColumn<String>(
//       'receiver_type', aliasedName, false,
//       type: DriftSqlType.string, requiredDuringInsert: true);
//   static const VerificationMeta _messageTextMeta =
//       const VerificationMeta('messageText');
//   @override
//   late final GeneratedColumn<String> messageText = GeneratedColumn<String>(
//       'message_text', aliasedName, false,
//       type: DriftSqlType.string, requiredDuringInsert: true);
//   static const VerificationMeta _messageTypeMeta =
//       const VerificationMeta('messageType');
//   @override
//   late final GeneratedColumn<String> messageType = GeneratedColumn<String>(
//       'message_type', aliasedName, false,
//       type: DriftSqlType.string, requiredDuringInsert: true);
//   static const VerificationMeta _filePathMeta =
//       const VerificationMeta('filePath');
//   @override
//   late final GeneratedColumn<String> filePath = GeneratedColumn<String>(
//       'file_path', aliasedName, true,
//       type: DriftSqlType.string, requiredDuringInsert: false);
//   static const VerificationMeta _senderMeta = const VerificationMeta('sender');
//   @override
//   late final GeneratedColumn<String> sender = GeneratedColumn<String>(
//       'sender', aliasedName, true,
//       type: DriftSqlType.string, requiredDuringInsert: false);
//   static const VerificationMeta _pinnedMeta = const VerificationMeta('pinned');
//   @override
//   late final GeneratedColumn<int> pinned = GeneratedColumn<int>(
//       'pinned', aliasedName, false,
//       type: DriftSqlType.int, requiredDuringInsert: true);
//   static const VerificationMeta _repliedMeta =
//       const VerificationMeta('replied');
//   @override
//   late final GeneratedColumn<String> replied = GeneratedColumn<String>(
//       'replied', aliasedName, true,
//       type: DriftSqlType.string, requiredDuringInsert: false);
//   static const VerificationMeta _roomIdentifierMeta =
//       const VerificationMeta('roomIdentifier');
//   @override
//   late final GeneratedColumn<String> roomIdentifier = GeneratedColumn<String>(
//       'room_identifier', aliasedName, false,
//       type: DriftSqlType.string, requiredDuringInsert: true);
//   static const VerificationMeta _isForwardedMeta =
//       const VerificationMeta('isForwarded');
//   @override
//   late final GeneratedColumn<bool> isForwarded = GeneratedColumn<bool>(
//       'is_forwarded', aliasedName, false,
//       type: DriftSqlType.bool,
//       requiredDuringInsert: false,
//       defaultConstraints: GeneratedColumn.constraintIsAlways(
//           'CHECK ("is_forwarded" IN (0, 1))'),
//       defaultValue: const Constant(false));
//   static const VerificationMeta _createdAtMeta =
//       const VerificationMeta('createdAt');
//   @override
//   late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
//       'created_at', aliasedName, false,
//       type: DriftSqlType.dateTime, requiredDuringInsert: true);
//   static const VerificationMeta _updatedAtMeta =
//       const VerificationMeta('updatedAt');
//   @override
//   late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
//       'updated_at', aliasedName, false,
//       type: DriftSqlType.dateTime, requiredDuringInsert: true);
//   static const VerificationMeta _readedAtMeta =
//       const VerificationMeta('readedAt');
//   @override
//   late final GeneratedColumn<DateTime> readedAt = GeneratedColumn<DateTime>(
//       'readed_at', aliasedName, true,
//       type: DriftSqlType.dateTime, requiredDuringInsert: false);
//   @override
//   List<GeneratedColumn> get $columns => [
//         id,
//         receiverId,
//         categoryId,
//         senderId,
//         receiverType,
//         messageText,
//         messageType,
//         filePath,
//         sender,
//         pinned,
//         replied,
//         roomIdentifier,
//         isForwarded,
//         createdAt,
//         updatedAt,
//         readedAt
//       ];
//   @override
//   String get aliasedName => _alias ?? actualTableName;
//   @override
//   String get actualTableName => $name;
//   static const String $name = 'message_table';
//   @override
//   VerificationContext validateIntegrity(Insertable<MessageTableData> instance,
//       {bool isInserting = false}) {
//     final context = VerificationContext();
//     final data = instance.toColumns(true);
//     if (data.containsKey('id')) {
//       context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
//     }
//     if (data.containsKey('receiver_id')) {
//       context.handle(
//           _receiverIdMeta,
//           receiverId.isAcceptableOrUnknown(
//               data['receiver_id']!, _receiverIdMeta));
//     } else if (isInserting) {
//       context.missing(_receiverIdMeta);
//     }
//     if (data.containsKey('category_id')) {
//       context.handle(
//           _categoryIdMeta,
//           categoryId.isAcceptableOrUnknown(
//               data['category_id']!, _categoryIdMeta));
//     } else if (isInserting) {
//       context.missing(_categoryIdMeta);
//     }
//     if (data.containsKey('sender_id')) {
//       context.handle(_senderIdMeta,
//           senderId.isAcceptableOrUnknown(data['sender_id']!, _senderIdMeta));
//     } else if (isInserting) {
//       context.missing(_senderIdMeta);
//     }
//     if (data.containsKey('receiver_type')) {
//       context.handle(
//           _receiverTypeMeta,
//           receiverType.isAcceptableOrUnknown(
//               data['receiver_type']!, _receiverTypeMeta));
//     } else if (isInserting) {
//       context.missing(_receiverTypeMeta);
//     }
//     if (data.containsKey('message_text')) {
//       context.handle(
//           _messageTextMeta,
//           messageText.isAcceptableOrUnknown(
//               data['message_text']!, _messageTextMeta));
//     } else if (isInserting) {
//       context.missing(_messageTextMeta);
//     }
//     if (data.containsKey('message_type')) {
//       context.handle(
//           _messageTypeMeta,
//           messageType.isAcceptableOrUnknown(
//               data['message_type']!, _messageTypeMeta));
//     } else if (isInserting) {
//       context.missing(_messageTypeMeta);
//     }
//     if (data.containsKey('file_path')) {
//       context.handle(_filePathMeta,
//           filePath.isAcceptableOrUnknown(data['file_path']!, _filePathMeta));
//     }
//     if (data.containsKey('sender')) {
//       context.handle(_senderMeta,
//           sender.isAcceptableOrUnknown(data['sender']!, _senderMeta));
//     }
//     if (data.containsKey('pinned')) {
//       context.handle(_pinnedMeta,
//           pinned.isAcceptableOrUnknown(data['pinned']!, _pinnedMeta));
//     } else if (isInserting) {
//       context.missing(_pinnedMeta);
//     }
//     if (data.containsKey('replied')) {
//       context.handle(_repliedMeta,
//           replied.isAcceptableOrUnknown(data['replied']!, _repliedMeta));
//     }
//     if (data.containsKey('room_identifier')) {
//       context.handle(
//           _roomIdentifierMeta,
//           roomIdentifier.isAcceptableOrUnknown(
//               data['room_identifier']!, _roomIdentifierMeta));
//     } else if (isInserting) {
//       context.missing(_roomIdentifierMeta);
//     }
//     if (data.containsKey('is_forwarded')) {
//       context.handle(
//           _isForwardedMeta,
//           isForwarded.isAcceptableOrUnknown(
//               data['is_forwarded']!, _isForwardedMeta));
//     }
//     if (data.containsKey('created_at')) {
//       context.handle(_createdAtMeta,
//           createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
//     } else if (isInserting) {
//       context.missing(_createdAtMeta);
//     }
//     if (data.containsKey('updated_at')) {
//       context.handle(_updatedAtMeta,
//           updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
//     } else if (isInserting) {
//       context.missing(_updatedAtMeta);
//     }
//     if (data.containsKey('readed_at')) {
//       context.handle(_readedAtMeta,
//           readedAt.isAcceptableOrUnknown(data['readed_at']!, _readedAtMeta));
//     }
//     return context;
//   }
//
//   @override
//   Set<GeneratedColumn> get $primaryKey => {id};
//   @override
//   MessageTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
//     final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
//     return MessageTableData(
//       id: attachedDatabase.typeMapping
//           .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
//       receiverId: attachedDatabase.typeMapping
//           .read(DriftSqlType.int, data['${effectivePrefix}receiver_id'])!,
//       categoryId: attachedDatabase.typeMapping
//           .read(DriftSqlType.int, data['${effectivePrefix}category_id'])!,
//       senderId: attachedDatabase.typeMapping
//           .read(DriftSqlType.int, data['${effectivePrefix}sender_id'])!,
//       receiverType: attachedDatabase.typeMapping
//           .read(DriftSqlType.string, data['${effectivePrefix}receiver_type'])!,
//       messageText: attachedDatabase.typeMapping
//           .read(DriftSqlType.string, data['${effectivePrefix}message_text'])!,
//       messageType: attachedDatabase.typeMapping
//           .read(DriftSqlType.string, data['${effectivePrefix}message_type'])!,
//       filePath: attachedDatabase.typeMapping
//           .read(DriftSqlType.string, data['${effectivePrefix}file_path']),
//       sender: attachedDatabase.typeMapping
//           .read(DriftSqlType.string, data['${effectivePrefix}sender']),
//       pinned: attachedDatabase.typeMapping
//           .read(DriftSqlType.int, data['${effectivePrefix}pinned'])!,
//       replied: attachedDatabase.typeMapping
//           .read(DriftSqlType.string, data['${effectivePrefix}replied']),
//       roomIdentifier: attachedDatabase.typeMapping.read(
//           DriftSqlType.string, data['${effectivePrefix}room_identifier'])!,
//       isForwarded: attachedDatabase.typeMapping
//           .read(DriftSqlType.bool, data['${effectivePrefix}is_forwarded'])!,
//       createdAt: attachedDatabase.typeMapping
//           .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
//       updatedAt: attachedDatabase.typeMapping
//           .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
//       readedAt: attachedDatabase.typeMapping
//           .read(DriftSqlType.dateTime, data['${effectivePrefix}readed_at']),
//     );
//   }
//
//   @override
//   $MessageTableTable createAlias(String alias) {
//     return $MessageTableTable(attachedDatabase, alias);
//   }
// }
//
// class MessageTableData extends DataClass
//     implements Insertable<MessageTableData> {
//   final int id;
//   final int receiverId;
//   final int categoryId;
//   final int senderId;
//   final String receiverType;
//   final String messageText;
//   final String messageType;
//   final String? filePath;
//   final String? sender;
//   final int pinned;
//   final String? replied;
//   final String roomIdentifier;
//   final bool isForwarded;
//   final DateTime createdAt;
//   final DateTime updatedAt;
//   final DateTime? readedAt;
//   const MessageTableData(
//       {required this.id,
//       required this.receiverId,
//       required this.categoryId,
//       required this.senderId,
//       required this.receiverType,
//       required this.messageText,
//       required this.messageType,
//       this.filePath,
//       this.sender,
//       required this.pinned,
//       this.replied,
//       required this.roomIdentifier,
//       required this.isForwarded,
//       required this.createdAt,
//       required this.updatedAt,
//       this.readedAt});
//   @override
//   Map<String, Expression> toColumns(bool nullToAbsent) {
//     final map = <String, Expression>{};
//     map['id'] = Variable<int>(id);
//     map['receiver_id'] = Variable<int>(receiverId);
//     map['category_id'] = Variable<int>(categoryId);
//     map['sender_id'] = Variable<int>(senderId);
//     map['receiver_type'] = Variable<String>(receiverType);
//     map['message_text'] = Variable<String>(messageText);
//     map['message_type'] = Variable<String>(messageType);
//     if (!nullToAbsent || filePath != null) {
//       map['file_path'] = Variable<String>(filePath);
//     }
//     if (!nullToAbsent || sender != null) {
//       map['sender'] = Variable<String>(sender);
//     }
//     map['pinned'] = Variable<int>(pinned);
//     if (!nullToAbsent || replied != null) {
//       map['replied'] = Variable<String>(replied);
//     }
//     map['room_identifier'] = Variable<String>(roomIdentifier);
//     map['is_forwarded'] = Variable<bool>(isForwarded);
//     map['created_at'] = Variable<DateTime>(createdAt);
//     map['updated_at'] = Variable<DateTime>(updatedAt);
//     if (!nullToAbsent || readedAt != null) {
//       map['readed_at'] = Variable<DateTime>(readedAt);
//     }
//     return map;
//   }
//
//   MessageTableCompanion toCompanion(bool nullToAbsent) {
//     return MessageTableCompanion(
//       id: Value(id),
//       receiverId: Value(receiverId),
//       categoryId: Value(categoryId),
//       senderId: Value(senderId),
//       receiverType: Value(receiverType),
//       messageText: Value(messageText),
//       messageType: Value(messageType),
//       filePath: filePath == null && nullToAbsent
//           ? const Value.absent()
//           : Value(filePath),
//       sender:
//           sender == null && nullToAbsent ? const Value.absent() : Value(sender),
//       pinned: Value(pinned),
//       replied: replied == null && nullToAbsent
//           ? const Value.absent()
//           : Value(replied),
//       roomIdentifier: Value(roomIdentifier),
//       isForwarded: Value(isForwarded),
//       createdAt: Value(createdAt),
//       updatedAt: Value(updatedAt),
//       readedAt: readedAt == null && nullToAbsent
//           ? const Value.absent()
//           : Value(readedAt),
//     );
//   }
//
//   factory MessageTableData.fromJson(Map<String, dynamic> json,
//       {ValueSerializer? serializer}) {
//     serializer ??= driftRuntimeOptions.defaultSerializer;
//     return MessageTableData(
//       id: serializer.fromJson<int>(json['id']),
//       receiverId: serializer.fromJson<int>(json['receiverId']),
//       categoryId: serializer.fromJson<int>(json['categoryId']),
//       senderId: serializer.fromJson<int>(json['senderId']),
//       receiverType: serializer.fromJson<String>(json['receiverType']),
//       messageText: serializer.fromJson<String>(json['messageText']),
//       messageType: serializer.fromJson<String>(json['messageType']),
//       filePath: serializer.fromJson<String?>(json['filePath']),
//       sender: serializer.fromJson<String?>(json['sender']),
//       pinned: serializer.fromJson<int>(json['pinned']),
//       replied: serializer.fromJson<String?>(json['replied']),
//       roomIdentifier: serializer.fromJson<String>(json['roomIdentifier']),
//       isForwarded: serializer.fromJson<bool>(json['isForwarded']),
//       createdAt: serializer.fromJson<DateTime>(json['createdAt']),
//       updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
//       readedAt: serializer.fromJson<DateTime?>(json['readedAt']),
//     );
//   }
//   @override
//   Map<String, dynamic> toJson({ValueSerializer? serializer}) {
//     serializer ??= driftRuntimeOptions.defaultSerializer;
//     return <String, dynamic>{
//       'id': serializer.toJson<int>(id),
//       'receiverId': serializer.toJson<int>(receiverId),
//       'categoryId': serializer.toJson<int>(categoryId),
//       'senderId': serializer.toJson<int>(senderId),
//       'receiverType': serializer.toJson<String>(receiverType),
//       'messageText': serializer.toJson<String>(messageText),
//       'messageType': serializer.toJson<String>(messageType),
//       'filePath': serializer.toJson<String?>(filePath),
//       'sender': serializer.toJson<String?>(sender),
//       'pinned': serializer.toJson<int>(pinned),
//       'replied': serializer.toJson<String?>(replied),
//       'roomIdentifier': serializer.toJson<String>(roomIdentifier),
//       'isForwarded': serializer.toJson<bool>(isForwarded),
//       'createdAt': serializer.toJson<DateTime>(createdAt),
//       'updatedAt': serializer.toJson<DateTime>(updatedAt),
//       'readedAt': serializer.toJson<DateTime?>(readedAt),
//     };
//   }
//
//   MessageTableData copyWith(
//           {int? id,
//           int? receiverId,
//           int? categoryId,
//           int? senderId,
//           String? receiverType,
//           String? messageText,
//           String? messageType,
//           Value<String?> filePath = const Value.absent(),
//           Value<String?> sender = const Value.absent(),
//           int? pinned,
//           Value<String?> replied = const Value.absent(),
//           String? roomIdentifier,
//           bool? isForwarded,
//           DateTime? createdAt,
//           DateTime? updatedAt,
//           Value<DateTime?> readedAt = const Value.absent()}) =>
//       MessageTableData(
//         id: id ?? this.id,
//         receiverId: receiverId ?? this.receiverId,
//         categoryId: categoryId ?? this.categoryId,
//         senderId: senderId ?? this.senderId,
//         receiverType: receiverType ?? this.receiverType,
//         messageText: messageText ?? this.messageText,
//         messageType: messageType ?? this.messageType,
//         filePath: filePath.present ? filePath.value : this.filePath,
//         sender: sender.present ? sender.value : this.sender,
//         pinned: pinned ?? this.pinned,
//         replied: replied.present ? replied.value : this.replied,
//         roomIdentifier: roomIdentifier ?? this.roomIdentifier,
//         isForwarded: isForwarded ?? this.isForwarded,
//         createdAt: createdAt ?? this.createdAt,
//         updatedAt: updatedAt ?? this.updatedAt,
//         readedAt: readedAt.present ? readedAt.value : this.readedAt,
//       );
//   @override
//   String toString() {
//     return (StringBuffer('MessageTableData(')
//           ..write('id: $id, ')
//           ..write('receiverId: $receiverId, ')
//           ..write('categoryId: $categoryId, ')
//           ..write('senderId: $senderId, ')
//           ..write('receiverType: $receiverType, ')
//           ..write('messageText: $messageText, ')
//           ..write('messageType: $messageType, ')
//           ..write('filePath: $filePath, ')
//           ..write('sender: $sender, ')
//           ..write('pinned: $pinned, ')
//           ..write('replied: $replied, ')
//           ..write('roomIdentifier: $roomIdentifier, ')
//           ..write('isForwarded: $isForwarded, ')
//           ..write('createdAt: $createdAt, ')
//           ..write('updatedAt: $updatedAt, ')
//           ..write('readedAt: $readedAt')
//           ..write(')'))
//         .toString();
//   }
//
//   @override
//   int get hashCode => Object.hash(
//       id,
//       receiverId,
//       categoryId,
//       senderId,
//       receiverType,
//       messageText,
//       messageType,
//       filePath,
//       sender,
//       pinned,
//       replied,
//       roomIdentifier,
//       isForwarded,
//       createdAt,
//       updatedAt,
//       readedAt);
//   @override
//   bool operator ==(Object other) =>
//       identical(this, other) ||
//       (other is MessageTableData &&
//           other.id == this.id &&
//           other.receiverId == this.receiverId &&
//           other.categoryId == this.categoryId &&
//           other.senderId == this.senderId &&
//           other.receiverType == this.receiverType &&
//           other.messageText == this.messageText &&
//           other.messageType == this.messageType &&
//           other.filePath == this.filePath &&
//           other.sender == this.sender &&
//           other.pinned == this.pinned &&
//           other.replied == this.replied &&
//           other.roomIdentifier == this.roomIdentifier &&
//           other.isForwarded == this.isForwarded &&
//           other.createdAt == this.createdAt &&
//           other.updatedAt == this.updatedAt &&
//           other.readedAt == this.readedAt);
// }
//
// class MessageTableCompanion extends UpdateCompanion<MessageTableData> {
//   final Value<int> id;
//   final Value<int> receiverId;
//   final Value<int> categoryId;
//   final Value<int> senderId;
//   final Value<String> receiverType;
//   final Value<String> messageText;
//   final Value<String> messageType;
//   final Value<String?> filePath;
//   final Value<String?> sender;
//   final Value<int> pinned;
//   final Value<String?> replied;
//   final Value<String> roomIdentifier;
//   final Value<bool> isForwarded;
//   final Value<DateTime> createdAt;
//   final Value<DateTime> updatedAt;
//   final Value<DateTime?> readedAt;
//   const MessageTableCompanion({
//     this.id = const Value.absent(),
//     this.receiverId = const Value.absent(),
//     this.categoryId = const Value.absent(),
//     this.senderId = const Value.absent(),
//     this.receiverType = const Value.absent(),
//     this.messageText = const Value.absent(),
//     this.messageType = const Value.absent(),
//     this.filePath = const Value.absent(),
//     this.sender = const Value.absent(),
//     this.pinned = const Value.absent(),
//     this.replied = const Value.absent(),
//     this.roomIdentifier = const Value.absent(),
//     this.isForwarded = const Value.absent(),
//     this.createdAt = const Value.absent(),
//     this.updatedAt = const Value.absent(),
//     this.readedAt = const Value.absent(),
//   });
//   MessageTableCompanion.insert({
//     this.id = const Value.absent(),
//     required int receiverId,
//     required int categoryId,
//     required int senderId,
//     required String receiverType,
//     required String messageText,
//     required String messageType,
//     this.filePath = const Value.absent(),
//     this.sender = const Value.absent(),
//     required int pinned,
//     this.replied = const Value.absent(),
//     required String roomIdentifier,
//     this.isForwarded = const Value.absent(),
//     required DateTime createdAt,
//     required DateTime updatedAt,
//     this.readedAt = const Value.absent(),
//   })  : receiverId = Value(receiverId),
//         categoryId = Value(categoryId),
//         senderId = Value(senderId),
//         receiverType = Value(receiverType),
//         messageText = Value(messageText),
//         messageType = Value(messageType),
//         pinned = Value(pinned),
//         roomIdentifier = Value(roomIdentifier),
//         createdAt = Value(createdAt),
//         updatedAt = Value(updatedAt);
//   static Insertable<MessageTableData> custom({
//     Expression<int>? id,
//     Expression<int>? receiverId,
//     Expression<int>? categoryId,
//     Expression<int>? senderId,
//     Expression<String>? receiverType,
//     Expression<String>? messageText,
//     Expression<String>? messageType,
//     Expression<String>? filePath,
//     Expression<String>? sender,
//     Expression<int>? pinned,
//     Expression<String>? replied,
//     Expression<String>? roomIdentifier,
//     Expression<bool>? isForwarded,
//     Expression<DateTime>? createdAt,
//     Expression<DateTime>? updatedAt,
//     Expression<DateTime>? readedAt,
//   }) {
//     return RawValuesInsertable({
//       if (id != null) 'id': id,
//       if (receiverId != null) 'receiver_id': receiverId,
//       if (categoryId != null) 'category_id': categoryId,
//       if (senderId != null) 'sender_id': senderId,
//       if (receiverType != null) 'receiver_type': receiverType,
//       if (messageText != null) 'message_text': messageText,
//       if (messageType != null) 'message_type': messageType,
//       if (filePath != null) 'file_path': filePath,
//       if (sender != null) 'sender': sender,
//       if (pinned != null) 'pinned': pinned,
//       if (replied != null) 'replied': replied,
//       if (roomIdentifier != null) 'room_identifier': roomIdentifier,
//       if (isForwarded != null) 'is_forwarded': isForwarded,
//       if (createdAt != null) 'created_at': createdAt,
//       if (updatedAt != null) 'updated_at': updatedAt,
//       if (readedAt != null) 'readed_at': readedAt,
//     });
//   }
//
//   MessageTableCompanion copyWith(
//       {Value<int>? id,
//       Value<int>? receiverId,
//       Value<int>? categoryId,
//       Value<int>? senderId,
//       Value<String>? receiverType,
//       Value<String>? messageText,
//       Value<String>? messageType,
//       Value<String?>? filePath,
//       Value<String?>? sender,
//       Value<int>? pinned,
//       Value<String?>? replied,
//       Value<String>? roomIdentifier,
//       Value<bool>? isForwarded,
//       Value<DateTime>? createdAt,
//       Value<DateTime>? updatedAt,
//       Value<DateTime?>? readedAt}) {
//     return MessageTableCompanion(
//       id: id ?? this.id,
//       receiverId: receiverId ?? this.receiverId,
//       categoryId: categoryId ?? this.categoryId,
//       senderId: senderId ?? this.senderId,
//       receiverType: receiverType ?? this.receiverType,
//       messageText: messageText ?? this.messageText,
//       messageType: messageType ?? this.messageType,
//       filePath: filePath ?? this.filePath,
//       sender: sender ?? this.sender,
//       pinned: pinned ?? this.pinned,
//       replied: replied ?? this.replied,
//       roomIdentifier: roomIdentifier ?? this.roomIdentifier,
//       isForwarded: isForwarded ?? this.isForwarded,
//       createdAt: createdAt ?? this.createdAt,
//       updatedAt: updatedAt ?? this.updatedAt,
//       readedAt: readedAt ?? this.readedAt,
//     );
//   }
//
//   @override
//   Map<String, Expression> toColumns(bool nullToAbsent) {
//     final map = <String, Expression>{};
//     if (id.present) {
//       map['id'] = Variable<int>(id.value);
//     }
//     if (receiverId.present) {
//       map['receiver_id'] = Variable<int>(receiverId.value);
//     }
//     if (categoryId.present) {
//       map['category_id'] = Variable<int>(categoryId.value);
//     }
//     if (senderId.present) {
//       map['sender_id'] = Variable<int>(senderId.value);
//     }
//     if (receiverType.present) {
//       map['receiver_type'] = Variable<String>(receiverType.value);
//     }
//     if (messageText.present) {
//       map['message_text'] = Variable<String>(messageText.value);
//     }
//     if (messageType.present) {
//       map['message_type'] = Variable<String>(messageType.value);
//     }
//     if (filePath.present) {
//       map['file_path'] = Variable<String>(filePath.value);
//     }
//     if (sender.present) {
//       map['sender'] = Variable<String>(sender.value);
//     }
//     if (pinned.present) {
//       map['pinned'] = Variable<int>(pinned.value);
//     }
//     if (replied.present) {
//       map['replied'] = Variable<String>(replied.value);
//     }
//     if (roomIdentifier.present) {
//       map['room_identifier'] = Variable<String>(roomIdentifier.value);
//     }
//     if (isForwarded.present) {
//       map['is_forwarded'] = Variable<bool>(isForwarded.value);
//     }
//     if (createdAt.present) {
//       map['created_at'] = Variable<DateTime>(createdAt.value);
//     }
//     if (updatedAt.present) {
//       map['updated_at'] = Variable<DateTime>(updatedAt.value);
//     }
//     if (readedAt.present) {
//       map['readed_at'] = Variable<DateTime>(readedAt.value);
//     }
//     return map;
//   }
//
//   @override
//   String toString() {
//     return (StringBuffer('MessageTableCompanion(')
//           ..write('id: $id, ')
//           ..write('receiverId: $receiverId, ')
//           ..write('categoryId: $categoryId, ')
//           ..write('senderId: $senderId, ')
//           ..write('receiverType: $receiverType, ')
//           ..write('messageText: $messageText, ')
//           ..write('messageType: $messageType, ')
//           ..write('filePath: $filePath, ')
//           ..write('sender: $sender, ')
//           ..write('pinned: $pinned, ')
//           ..write('replied: $replied, ')
//           ..write('roomIdentifier: $roomIdentifier, ')
//           ..write('isForwarded: $isForwarded, ')
//           ..write('createdAt: $createdAt, ')
//           ..write('updatedAt: $updatedAt, ')
//           ..write('readedAt: $readedAt')
//           ..write(')'))
//         .toString();
//   }
// }
//
// abstract class _$SQLiteLocalStorage extends GeneratedDatabase {
//   _$SQLiteLocalStorage(QueryExecutor e) : super(e);
//   late final $ChatsTableTable chatsTable = $ChatsTableTable(this);
//   late final $MessageTableTable messageTable = $MessageTableTable(this);
//   @override
//   Iterable<TableInfo<Table, Object?>> get allTables =>
//       allSchemaEntities.whereType<TableInfo<Table, Object?>>();
//   @override
//   List<DatabaseSchemaEntity> get allSchemaEntities =>
//       [chatsTable, messageTable];
// }
