import 'package:api_handler/feature/api_handler/data/models/response_model.dart';
import 'package:messaging_core/core/services/media_handler/file_model.dart';
import 'package:messaging_core/core/usecase/usecase.dart';
import 'package:messaging_core/features/chat/domain/repositories/chat_repository.dart';

class CreateGroupUseCase
    implements UseCase<Future<ResponseModel>, CreateGroupParams> {
  final ChatRepository _chatRepository;

  CreateGroupUseCase(this._chatRepository);

  @override
  Future<ResponseModel> call(CreateGroupParams params) {
    return _chatRepository.createGroup(
        params.groupName, params.users, params.file);
  }
}

class CreateGroupParams {
  String groupName;
  List<int> users;
  FileModel? file;

  CreateGroupParams({required this.groupName, required this.users, this.file});
}
