// import 'package:drift/drift.dart';
import 'package:messaging_core/core/storage/database.dart';
import 'package:messaging_core/features/chat/domain/entities/chats_parent_model.dart';
import 'package:messaging_core/features/chat/domain/entities/content_model.dart';
import 'package:messaging_core/features/chat/domain/repositories/storage/chat_storage_repository.dart';

class ChatStorageRepositoryImpl extends ChatStorageRepository {
  // final SQLiteLocalStorage database;

  // ChatStorageRepositoryImpl({
  // required this.database,
  // });

  @override
  Future<ChatParentClass?> getChat(int chatId) async {
    // final channelData = await (database.chatsTable.select()
    //       ..where((tbl) => tbl.id.equals(chatId)))
    //     .getSingleOrNull();
    return
        // channelData != null
        //   ? ChatParentClass.fromChatTable(channelData)
        //   :
        null;
  }

  // @override
  // Future<List<ChatParentClass>> getChats() async {
  //   // final channels = await (database.chatsTable.select()
  //   //       // ..limit(limit, offset: (offset - 1) * limit)
  //   //       ..orderBy([
  //   //         (tbl) =>
  //   //             OrderingTerm(expression: tbl.updatedAt, mode: OrderingMode.desc)
  //   //       ]))
  //   //     .get();
  //   return List<ChatParentClass>.from(
  //
  //       // channels.map((data) => ChatParentClass.fromChatTable(data)
  //       // ),
  //       );
  // }

  @override
  // Future<List<ContentModel>> getMessages(String roomIdentifier) async {
  //   // final channels = await (database.messageTable.select()
  //   //       ..where((tbl) => tbl.roomIdentifier.equals(roomIdentifier)
  //   // ..limit(limit, offset: (offset - 1) * limit)
  //   //   ..orderBy([
  //   //         (tbl) =>
  //   //         OrderingTerm(expression: tbl.updatedAt, mode: OrderingMode.desc)
  //   //   ]
  //   //   )
  //   // ))
  //   // .get();
  //   return List<ContentModel>.from(
  //
  //       // channels.map((data) => ContentModel.fromMessagesTable(data))
  //       );
  // }

  @override
  Future<void> saveChat(ChatParentClass chat) async {
    // await database.chatsTable.insertOnConflictUpdate(chat.toChatTableData());
  }

  @override
  Future<void> saveChats(List<ChatParentClass> chats) async {
    // await database.batch((batch) {
    //   batch.insertAllOnConflictUpdate(
    //     database.chatsTable,
    //     List<ChatsTableData>.from(chats.map((chat) => chat.toChatTableData())),
    //   );
    // });
  }

  @override
  Future<void> saveMessages(
      List<ContentModel> messages, String roomIdentifier) async {
    // await database.batch((batch) {
    //   batch.insertAllOnConflictUpdate(
    //     database.messageTable,
    //     List<MessageTableData>.from(
    //         messages.map((chat) => chat.toMessagesTableData(roomIdentifier))),
    //   );
    // });
  }
}
