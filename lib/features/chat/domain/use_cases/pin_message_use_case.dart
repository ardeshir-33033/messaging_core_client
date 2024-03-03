import 'package:api_handler/feature/api_handler/data/models/response_model.dart';
import 'package:messaging_core/core/usecase/usecase.dart';
import 'package:messaging_core/features/chat/domain/repositories/chat_repository.dart';

class PinMessageUseCase implements UseCase<Future<ResponseModel>, int> {
  final ChatRepository _chatRepository;

  PinMessageUseCase(this._chatRepository);

  @override
  Future<ResponseModel> call(int messageId) {
    return _chatRepository.pinMessage(messageId);
  }
}
