import 'package:api_handler/feature/api_handler/data/models/response_model.dart';
import 'package:messaging_core/core/usecase/usecase.dart';
import 'package:messaging_core/features/chat/domain/repositories/chat_repository.dart';

class PinMessageUseCase implements UseCase<Future<ResponseModel>, PinMessageParams> {
  final ChatRepository _chatRepository;

  PinMessageUseCase(this._chatRepository);

  @override
  Future<ResponseModel> call(PinMessageParams params) {
    return _chatRepository.pinMessage(params.messageId, params.pin);
  }
}

class PinMessageParams {
  int messageId;
  bool pin;

  PinMessageParams(this.messageId, this.pin);
}
