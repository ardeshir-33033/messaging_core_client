import 'package:messaging_core/core/usecase/usecase.dart';
import 'package:messaging_core/features/chat/domain/repositories/chat_repository.dart';

class UpdateReadUseCase implements UseCase<Future<bool>, int> {
  final ChatRepository _chatRepository;

  UpdateReadUseCase(this._chatRepository);

  @override
  Future<bool> call(int messageId) {
    return _chatRepository.updateRead(messageId);
  }
}
