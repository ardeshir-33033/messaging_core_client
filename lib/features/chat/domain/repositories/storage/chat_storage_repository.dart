import 'package:messaging_core/features/chat/domain/entities/chats_parent_model.dart';

abstract class ChatStorageRepository {
  Future<void> saveChats(List<ChatParentClass> chats);
  Future<void> saveChat(ChatParentClass chat);

  Future<List<ChatParentClass>> getChats();
  Future<ChatParentClass?> getChat(int chatId);
}
