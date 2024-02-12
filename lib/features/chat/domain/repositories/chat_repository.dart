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
}
