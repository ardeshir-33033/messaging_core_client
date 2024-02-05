import 'package:api_handler/feature/api_handler/data/models/response_model.dart';

abstract class ChatRepository {
  Future<ResponseModel> getAllChats();
}