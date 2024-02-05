import 'package:api_handler/feature/api_handler/data/models/response_model.dart';
import 'package:messaging_core/core/usecase/usecase.dart';
import 'package:messaging_core/features/chat/domain/repositories/chat_repository.dart';

class GetAllChatsUseCase implements UseCase<Future<ResponseModel>, void> {
  final ChatRepository _chatRepository;

  GetAllChatsUseCase(this._chatRepository);


  @override
  Future<ResponseModel> call(void params) {
    return _chatRepository.getAllChats();
  }
}
