import 'package:get/get.dart';
import 'package:messaging_core/features/chat/domain/use_cases/get_all_chats_use_case.dart';

class ChatController extends GetxController {
  final GetAllChatsUseCase getAllChatsUseCase;

  ChatController(this.getAllChatsUseCase);


}
