import 'package:api_handler/feature/api_handler/data/models/response_model.dart';
import 'package:messaging_core/core/usecase/usecase.dart';
import 'package:messaging_core/features/chat/domain/repositories/chat_repository.dart';

class EditMessagesUseCase
    implements UseCase<Future<ResponseModel>, EditMessagesParams> {
  final ChatRepository _chatRepository;

  EditMessagesUseCase(this._chatRepository);

  @override
  Future<ResponseModel> call(EditMessagesParams params) {
    return _chatRepository.editMessages(params.newMessage, params.messageId);
  }
}

class EditMessagesParams {
  String newMessage;
  int messageId;

  EditMessagesParams({required this.newMessage, required this.messageId});
}
