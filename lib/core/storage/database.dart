import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:messaging_core/core/storage/sqllite/tables/chats_table.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'database.g.dart';

@DriftDatabase(
  tables: [
    ChatsTable,
  ],
)
class SQLiteLocalStorage extends _$SQLiteLocalStorage {
  SQLiteLocalStorage({
    DatabaseConnection? connection,
  }) : super(connection ?? _openConnection());

  @override
  int get schemaVersion => 1;

  Future<void> clearTables() async {
    await chatsTable.deleteAll();
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
