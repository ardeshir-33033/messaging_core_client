import 'package:api_handler/feature/api_handler/data/models/response_model.dart';
import 'package:messaging_core/core/services/media_handler/file_model.dart';
import 'package:messaging_core/core/usecase/usecase.dart';
import 'package:messaging_core/features/chat/domain/repositories/chat_repository.dart';

class EditGroupUseCase
    implements UseCase<Future<ResponseModel>, EditGroupParams> {
  final ChatRepository _chatRepository;

  EditGroupUseCase(this._chatRepository);

  @override
  Future<ResponseModel> call(EditGroupParams params) {
    return _chatRepository.editGroup(
        params.groupName, params.users, params.groupId, params.file);
  }
}

class EditGroupParams {
  String groupName;
  List<int> users;
  int groupId;
  FileModel? file;

  EditGroupParams(
      {required this.groupName,
      required this.users,
      required this.groupId,
      this.file});
}
