import 'package:api_handler/api_handler.dart';
import 'package:api_handler/feature/api_handler/data/models/response_model.dart';
import 'package:messaging_core/core/enums/receiver_type.dart';
import 'package:messaging_core/core/services/media_handler/file_model.dart';
import 'package:messaging_core/features/chat/domain/entities/content_model.dart';
import 'package:messaging_core/features/chat/domain/repositories/chat_repository.dart';

import '../data_sources/chat_data_source.dart';

class ChatRepositoryImpl extends ChatRepository {
  final ChatDataSource _chatDataSource;

  ChatRepositoryImpl(this._chatDataSource);

  @override
  Future<ResponseModel> getAllChats() async {
    try {
      return await _chatDataSource.getUsersInCategory();
    } catch (e) {
      return ResponseModel(
        statusCode: 510,
        result: ResultEnum.error,
        message: e.toString(),
      );
    }
  }

  @override
  Future<ResponseModel> getMessages(
      ReceiverType receiverType, int senderId, int receiverId) async {
    try {
      return await _chatDataSource.showMessagesInGroup(
          receiverType, senderId, receiverId);
    } catch (e) {
      return ResponseModel(
        statusCode: 510,
        result: ResultEnum.error,
        message: e.toString(),
      );
    }
  }

  @override
  sendMessages(ContentModel contentModel, List<String>? receivingUsers,
      FileModel? file) async {
    try {
      return await _chatDataSource.sendMessages(
          contentModel, receivingUsers, file);
    } catch (e) {
      return ResponseModel(
        statusCode: 510,
        result: ResultEnum.error,
        message: e.toString(),
      );
    }
  }
}
