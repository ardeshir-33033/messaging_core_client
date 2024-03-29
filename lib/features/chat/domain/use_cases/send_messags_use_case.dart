import 'package:api_handler/feature/api_handler/data/models/response_model.dart';
import 'package:messaging_core/core/services/media_handler/file_model.dart';
import 'package:messaging_core/core/usecase/usecase.dart';
import 'package:messaging_core/features/chat/domain/entities/content_model.dart';
import 'package:messaging_core/features/chat/domain/repositories/chat_repository.dart';

class SendMessagesUseCase
    implements UseCase<Future<ResponseModel>, SendMessagesParams> {
  final ChatRepository _chatRepository;

  SendMessagesUseCase(this._chatRepository);

  @override
  Future<ResponseModel> call(SendMessagesParams params) {
    return _chatRepository.sendMessages(params.contentModel, params.file);
  }
}

class SendMessagesParams {
  ContentModel contentModel;
  FileModel? file;

  SendMessagesParams({required this.contentModel, this.file});
}
