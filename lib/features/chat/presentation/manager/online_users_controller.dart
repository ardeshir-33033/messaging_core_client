import 'package:get/get.dart';
import 'package:messaging_core/features/chat/presentation/manager/chat_controller.dart';
import 'package:messaging_core/locator.dart';

class OnlineUsersController extends GetxController {
  List<int> onlineUsers = [];

  setOnlineUsers(List<int> users) {
    onlineUsers = [];
    onlineUsers.addAll(users);
    ChatController chatController = locator<ChatController>();
    chatController.update(["allChats"]);
  }
}
