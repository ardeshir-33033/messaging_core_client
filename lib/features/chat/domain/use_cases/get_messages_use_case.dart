import 'package:api_handler/feature/api_handler/data/models/response_model.dart';
import 'package:messaging_core/core/enums/receiver_type.dart';
import 'package:messaging_core/core/usecase/usecase.dart';
import 'package:messaging_core/features/chat/domain/repositories/chat_repository.dart';

class GetMessagesUseCase
    implements UseCase<Future<ResponseModel>, GetMessagesParams> {
  final ChatRepository _chatRepository;

  GetMessagesUseCase(this._chatRepository);

  @override
  Future<ResponseModel> call(GetMessagesParams params) {
    return _chatRepository.getMessages(
        params.receiverType, params.senderId, params.receiverId);
  }
}

class GetMessagesParams {
  ReceiverType receiverType;
  int? senderId;
  int receiverId;

  GetMessagesParams(
      {required this.receiverType, required this.receiverId, this.senderId});
}
