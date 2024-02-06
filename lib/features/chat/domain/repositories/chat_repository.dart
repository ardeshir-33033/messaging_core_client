import 'package:api_handler/feature/api_handler/data/models/response_model.dart';
import 'package:messaging_core/core/enums/receiver_type.dart';

abstract class ChatRepository {
  Future<ResponseModel> getAllChats();
  Future<ResponseModel> getMessages(
      ReceiverType receiverType, int senderId, int receiverId);
}
