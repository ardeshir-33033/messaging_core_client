import 'package:api_handler/api_handler.dart';
import 'package:api_handler/feature/api_handler/data/models/response_model.dart';
import 'package:messaging_core/features/chat/domain/repositories/chat_repository.dart';

import '../data_sources/chat_data_source.dart';

class ChatRepositoryImpl extends ChatRepository {
  final ChatDataSource _chatDataSource;

  ChatRepositoryImpl(this._chatDataSource);

  @override
  Future<ResponseModel> getAllChats() async {
    try {
      return await _chatDataSource.getGroupChatsInCategory();
    } catch (e) {
      return ResponseModel(
        statusCode: 510,
        result: ResultEnum.error,
        message: e.toString(),
      );
    }
  }
}