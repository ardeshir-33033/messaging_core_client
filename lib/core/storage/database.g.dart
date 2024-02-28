// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $ChatsTableTable extends ChatsTable
    with TableInfo<$ChatsTableTable, ChatsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChatsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _creatorUserIdMeta =
      const VerificationMeta('creatorUserId');
  @override
  late final GeneratedColumn<int> creatorUserId = GeneratedColumn<int>(
      'creator_user_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _categoryIdMeta =
      const VerificationMeta('categoryId');
  @override
  late final GeneratedColumn<int> categoryId = GeneratedColumn<int>(
      'category_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _levelMeta = const VerificationMeta('level');
  @override
  late final GeneratedColumn<int> level = GeneratedColumn<int>(
      'level', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _avatarMeta = const VerificationMeta('avatar');
  @override
  late final GeneratedColumn<String> avatar = GeneratedColumn<String>(
      'avatar', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _usernameMeta =
      const VerificationMeta('username');
  @override
  late final GeneratedColumn<String> username = GeneratedColumn<String>(
      'username', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _groupUsersMeta =
      const VerificationMeta('groupUsers');
  @override
  late final GeneratedColumn<String> groupUsers = GeneratedColumn<String>(
      'group_users', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _lastMessageMeta =
      const VerificationMeta('lastMessage');
  @override
  late final GeneratedColumn<String> lastMessage = GeneratedColumn<String>(
      'last_message', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _lastReadMeta =
      const VerificationMeta('lastRead');
  @override
  late final GeneratedColumn<String> lastRead = GeneratedColumn<String>(
      'last_read', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        creatorUserId,
        categoryId,
        level,
        name,
        avatar,
        username,
        status,
        groupUsers,
        lastMessage,
        lastRead,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'chats_table';
  @override
  VerificationContext validateIntegrity(Insertable<ChatsTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('creator_user_id')) {
      context.handle(
          _creatorUserIdMeta,
          creatorUserId.isAcceptableOrUnknown(
              data['creator_user_id']!, _creatorUserIdMeta));
    }
    if (data.containsKey('category_id')) {
      context.handle(
          _categoryIdMeta,
          categoryId.isAcceptableOrUnknown(
              data['category_id']!, _categoryIdMeta));
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    if (data.containsKey('level')) {
      context.handle(
          _levelMeta, level.isAcceptableOrUnknown(data['level']!, _levelMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    }
    if (data.containsKey('avatar')) {
      context.handle(_avatarMeta,
          avatar.isAcceptableOrUnknown(data['avatar']!, _avatarMeta));
    }
    if (data.containsKey('username')) {
      context.handle(_usernameMeta,
          username.isAcceptableOrUnknown(data['username']!, _usernameMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('group_users')) {
      context.handle(
          _groupUsersMeta,
          groupUsers.isAcceptableOrUnknown(
              data['group_users']!, _groupUsersMeta));
    }
    if (data.containsKey('last_message')) {
      context.handle(
          _lastMessageMeta,
          lastMessage.isAcceptableOrUnknown(
              data['last_message']!, _lastMessageMeta));
    }
    if (data.containsKey('last_read')) {
      context.handle(_lastReadMeta,
          lastRead.isAcceptableOrUnknown(data['last_read']!, _lastReadMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ChatsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ChatsTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      creatorUserId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}creator_user_id']),
      categoryId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}category_id'])!,
      level: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}level']),
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name']),
      avatar: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}avatar']),
      username: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}username']),
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status']),
      groupUsers: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}group_users']),
      lastMessage: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}last_message']),
      lastRead: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}last_read']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at']),
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at']),
    );
  }

  @override
  $ChatsTableTable createAlias(String alias) {
    return $ChatsTableTable(attachedDatabase, alias);
  }
}

class ChatsTableData extends DataClass implements Insertable<ChatsTableData> {
  final int id;
  final int? creatorUserId;
  final int categoryId;
  final int? level;
  final String? name;
  final String? avatar;
  final String? username;
  final String? status;
  final String? groupUsers;
  final String? lastMessage;
  final String? lastRead;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  const ChatsTableData(
      {required this.id,
      this.creatorUserId,
      required this.categoryId,
      this.level,
      this.name,
      this.avatar,
      this.username,
      this.status,
      this.groupUsers,
      this.lastMessage,
      this.lastRead,
      this.createdAt,
      this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || creatorUserId != null) {
      map['creator_user_id'] = Variable<int>(creatorUserId);
    }
    map['category_id'] = Variable<int>(categoryId);
    if (!nullToAbsent || level != null) {
      map['level'] = Variable<int>(level);
    }
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    if (!nullToAbsent || avatar != null) {
      map['avatar'] = Variable<String>(avatar);
    }
    if (!nullToAbsent || username != null) {
      map['username'] = Variable<String>(username);
    }
    if (!nullToAbsent || status != null) {
      map['status'] = Variable<String>(status);
    }
    if (!nullToAbsent || groupUsers != null) {
      map['group_users'] = Variable<String>(groupUsers);
    }
    if (!nullToAbsent || lastMessage != null) {
      map['last_message'] = Variable<String>(lastMessage);
    }
    if (!nullToAbsent || lastRead != null) {
      map['last_read'] = Variable<String>(lastRead);
    }
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    return map;
  }

  ChatsTableCompanion toCompanion(bool nullToAbsent) {
    return ChatsTableCompanion(
      id: Value(id),
      creatorUserId: creatorUserId == null && nullToAbsent
          ? const Value.absent()
          : Value(creatorUserId),
      categoryId: Value(categoryId),
      level:
          level == null && nullToAbsent ? const Value.absent() : Value(level),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      avatar:
          avatar == null && nullToAbsent ? const Value.absent() : Value(avatar),
      username: username == null && nullToAbsent
          ? const Value.absent()
          : Value(username),
      status:
          status == null && nullToAbsent ? const Value.absent() : Value(status),
      groupUsers: groupUsers == null && nullToAbsent
          ? const Value.absent()
          : Value(groupUsers),
      lastMessage: lastMessage == null && nullToAbsent
          ? const Value.absent()
          : Value(lastMessage),
      lastRead: lastRead == null && nullToAbsent
          ? const Value.absent()
          : Value(lastRead),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory ChatsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ChatsTableData(
      id: serializer.fromJson<int>(json['id']),
      creatorUserId: serializer.fromJson<int?>(json['creatorUserId']),
      categoryId: serializer.fromJson<int>(json['categoryId']),
      level: serializer.fromJson<int?>(json['level']),
      name: serializer.fromJson<String?>(json['name']),
      avatar: serializer.fromJson<String?>(json['avatar']),
      username: serializer.fromJson<String?>(json['username']),
      status: serializer.fromJson<String?>(json['status']),
      groupUsers: serializer.fromJson<String?>(json['groupUsers']),
      lastMessage: serializer.fromJson<String?>(json['lastMessage']),
      lastRead: serializer.fromJson<String?>(json['lastRead']),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'creatorUserId': serializer.toJson<int?>(creatorUserId),
      'categoryId': serializer.toJson<int>(categoryId),
      'level': serializer.toJson<int?>(level),
      'name': serializer.toJson<String?>(name),
      'avatar': serializer.toJson<String?>(avatar),
      'username': serializer.toJson<String?>(username),
      'status': serializer.toJson<String?>(status),
      'groupUsers': serializer.toJson<String?>(groupUsers),
      'lastMessage': serializer.toJson<String?>(lastMessage),
      'lastRead': serializer.toJson<String?>(lastRead),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
    };
  }

  ChatsTableData copyWith(
          {int? id,
          Value<int?> creatorUserId = const Value.absent(),
          int? categoryId,
          Value<int?> level = const Value.absent(),
          Value<String?> name = const Value.absent(),
          Value<String?> avatar = const Value.absent(),
          Value<String?> username = const Value.absent(),
          Value<String?> status = const Value.absent(),
          Value<String?> groupUsers = const Value.absent(),
          Value<String?> lastMessage = const Value.absent(),
          Value<String?> lastRead = const Value.absent(),
          Value<DateTime?> createdAt = const Value.absent(),
          Value<DateTime?> updatedAt = const Value.absent()}) =>
      ChatsTableData(
        id: id ?? this.id,
        creatorUserId:
            creatorUserId.present ? creatorUserId.value : this.creatorUserId,
        categoryId: categoryId ?? this.categoryId,
        level: level.present ? level.value : this.level,
        name: name.present ? name.value : this.name,
        avatar: avatar.present ? avatar.value : this.avatar,
        username: username.present ? username.value : this.username,
        status: status.present ? status.value : this.status,
        groupUsers: groupUsers.present ? groupUsers.value : this.groupUsers,
        lastMessage: lastMessage.present ? lastMessage.value : this.lastMessage,
        lastRead: lastRead.present ? lastRead.value : this.lastRead,
        createdAt: createdAt.present ? createdAt.value : this.createdAt,
        updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
      );
  @override
  String toString() {
    return (StringBuffer('ChatsTableData(')
          ..write('id: $id, ')
          ..write('creatorUserId: $creatorUserId, ')
          ..write('categoryId: $categoryId, ')
          ..write('level: $level, ')
          ..write('name: $name, ')
          ..write('avatar: $avatar, ')
          ..write('username: $username, ')
          ..write('status: $status, ')
          ..write('groupUsers: $groupUsers, ')
          ..write('lastMessage: $lastMessage, ')
          ..write('lastRead: $lastRead, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      creatorUserId,
      categoryId,
      level,
      name,
      avatar,
      username,
      status,
      groupUsers,
      lastMessage,
      lastRead,
      createdAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChatsTableData &&
          other.id == this.id &&
          other.creatorUserId == this.creatorUserId &&
          other.categoryId == this.categoryId &&
          other.level == this.level &&
          other.name == this.name &&
          other.avatar == this.avatar &&
          other.username == this.username &&
          other.status == this.status &&
          other.groupUsers == this.groupUsers &&
          other.lastMessage == this.lastMessage &&
          other.lastRead == this.lastRead &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ChatsTableCompanion extends UpdateCompanion<ChatsTableData> {
  final Value<int> id;
  final Value<int?> creatorUserId;
  final Value<int> categoryId;
  final Value<int?> level;
  final Value<String?> name;
  final Value<String?> avatar;
  final Value<String?> username;
  final Value<String?> status;
  final Value<String?> groupUsers;
  final Value<String?> lastMessage;
  final Value<String?> lastRead;
  final Value<DateTime?> createdAt;
  final Value<DateTime?> updatedAt;
  const ChatsTableCompanion({
    this.id = const Value.absent(),
    this.creatorUserId = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.level = const Value.absent(),
    this.name = const Value.absent(),
    this.avatar = const Value.absent(),
    this.username = const Value.absent(),
    this.status = const Value.absent(),
    this.groupUsers = const Value.absent(),
    this.lastMessage = const Value.absent(),
    this.lastRead = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  ChatsTableCompanion.insert({
    this.id = const Value.absent(),
    this.creatorUserId = const Value.absent(),
    required int categoryId,
    this.level = const Value.absent(),
    this.name = const Value.absent(),
    this.avatar = const Value.absent(),
    this.username = const Value.absent(),
    this.status = const Value.absent(),
    this.groupUsers = const Value.absent(),
    this.lastMessage = const Value.absent(),
    this.lastRead = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : categoryId = Value(categoryId);
  static Insertable<ChatsTableData> custom({
    Expression<int>? id,
    Expression<int>? creatorUserId,
    Expression<int>? categoryId,
    Expression<int>? level,
    Expression<String>? name,
    Expression<String>? avatar,
    Expression<String>? username,
    Expression<String>? status,
    Expression<String>? groupUsers,
    Expression<String>? lastMessage,
    Expression<String>? lastRead,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (creatorUserId != null) 'creator_user_id': creatorUserId,
      if (categoryId != null) 'category_id': categoryId,
      if (level != null) 'level': level,
      if (name != null) 'name': name,
      if (avatar != null) 'avatar': avatar,
      if (username != null) 'username': username,
      if (status != null) 'status': status,
      if (groupUsers != null) 'group_users': groupUsers,
      if (lastMessage != null) 'last_message': lastMessage,
      if (lastRead != null) 'last_read': lastRead,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  ChatsTableCompanion copyWith(
      {Value<int>? id,
      Value<int?>? creatorUserId,
      Value<int>? categoryId,
      Value<int?>? level,
      Value<String?>? name,
      Value<String?>? avatar,
      Value<String?>? username,
      Value<String?>? status,
      Value<String?>? groupUsers,
      Value<String?>? lastMessage,
      Value<String?>? lastRead,
      Value<DateTime?>? createdAt,
      Value<DateTime?>? updatedAt}) {
    return ChatsTableCompanion(
      id: id ?? this.id,
      creatorUserId: creatorUserId ?? this.creatorUserId,
      categoryId: categoryId ?? this.categoryId,
      level: level ?? this.level,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      username: username ?? this.username,
      status: status ?? this.status,
      groupUsers: groupUsers ?? this.groupUsers,
      lastMessage: lastMessage ?? this.lastMessage,
      lastRead: lastRead ?? this.lastRead,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (creatorUserId.present) {
      map['creator_user_id'] = Variable<int>(creatorUserId.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<int>(categoryId.value);
    }
    if (level.present) {
      map['level'] = Variable<int>(level.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (avatar.present) {
      map['avatar'] = Variable<String>(avatar.value);
    }
    if (username.present) {
      map['username'] = Variable<String>(username.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (groupUsers.present) {
      map['group_users'] = Variable<String>(groupUsers.value);
    }
    if (lastMessage.present) {
      map['last_message'] = Variable<String>(lastMessage.value);
    }
    if (lastRead.present) {
      map['last_read'] = Variable<String>(lastRead.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChatsTableCompanion(')
          ..write('id: $id, ')
          ..write('creatorUserId: $creatorUserId, ')
          ..write('categoryId: $categoryId, ')
          ..write('level: $level, ')
          ..write('name: $name, ')
          ..write('avatar: $avatar, ')
          ..write('username: $username, ')
          ..write('status: $status, ')
          ..write('groupUsers: $groupUsers, ')
          ..write('lastMessage: $lastMessage, ')
          ..write('lastRead: $lastRead, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$SQLiteLocalStorage extends GeneratedDatabase {
  _$SQLiteLocalStorage(QueryExecutor e) : super(e);
  late final $ChatsTableTable chatsTable = $ChatsTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [chatsTable];
}
