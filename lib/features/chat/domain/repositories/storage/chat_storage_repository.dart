import 'package:messaging_core/features/chat/domain/entities/chats_parent_model.dart';
import 'package:messaging_core/features/chat/domain/entities/content_model.dart';

abstract class ChatStorageRepository {
  Future<void> saveChats(List<ChatParentClass> chats);
  Future<void> saveChat(ChatParentClass chat);

  // Future<void> saveMessages(List<ContentModel> messages, String roomIdentifier);

  // Future<List<ChatParentClass>> getChats();
  Future<ChatParentClass?> getChat(int chatId);

  // Future<List<ContentModel>> getMessages(String roomIdentifier);
}
