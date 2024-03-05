import 'package:api_handler/feature/api_handler/data/models/response_model.dart';
import 'package:messaging_core/core/enums/receiver_type.dart';
import 'package:messaging_core/core/services/media_handler/file_model.dart';
import 'package:messaging_core/features/chat/domain/entities/content_model.dart';

abstract class ChatRepository {
  Future<ResponseModel> getAllChats();
  Future<ResponseModel> getMessages(
      ReceiverType receiverType, int? senderId, int receiverId);
  Future<ResponseModel> sendMessages(
      ContentModel contentModel, FileModel? file);
  Future<ResponseModel> editMessages(String newText, int messageId);
  Future<ResponseModel> createGroup(
      String groupName, List<int> users, FileModel? file);
  Future<ResponseModel> editGroup(
      String groupName, List<int> users, int groupId, FileModel? file);
  Future<ResponseModel> deleteMessage(int messageId);
  Future<bool> updateRead(int messageId);
  Future<ResponseModel> pinMessage(int messageId);
}
