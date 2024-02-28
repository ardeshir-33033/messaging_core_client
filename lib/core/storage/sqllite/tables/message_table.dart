import 'package:drift/drift.dart';

class MessageTable extends Table {
  IntColumn get id => integer()();

  IntColumn get receiverId => integer()();

  IntColumn get categoryId => integer()();

  IntColumn get senderId => integer()();

  TextColumn get receiverType => text()();

  TextColumn get messageText => text()();

  TextColumn get messageType => text()();

  TextColumn get filePath => text().nullable()();

  DateTimeColumn get createdAt => dateTime()();

  DateTimeColumn get updatedAt => dateTime()();

  DateTimeColumn get readedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
