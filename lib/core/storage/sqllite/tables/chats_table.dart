import 'package:drift/drift.dart';

class ChatsTable extends Table {
  IntColumn get id => integer()();

  IntColumn get creatorUserId => integer().nullable()();

  IntColumn get categoryId => integer()();

  IntColumn get level => integer().nullable()();

  TextColumn get name => text().nullable()();

  TextColumn get avatar => text().nullable()();

  TextColumn get username => text().nullable()();

  TextColumn get status => text().nullable()();

  DateTimeColumn get createdAt => dateTime().nullable()();

  DateTimeColumn get updatedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};

  // TextColumn get channelSubscriptionStatus => text()
  //     .withDefault(const Constant('subscribed'))
  //     .map(const ChannelSubscriptionStatusConvertor())();
}
