import 'package:messaging_core/core/services/network/websocket/web_socket_connection.dart';
import 'package:messaging_core/features/chat/domain/entities/content_model.dart';

class MessagingClient {
  final WebSocketConnection webSocketConnection;

  MessagingClient(this.webSocketConnection);

  void initState() {
    webSocketConnection.initState();
  }

  void resetState() {}

  // void connect({required String token}) {
  //   webSocketManager.connect(token: token);
  //   Timer.periodic(const Duration(seconds: 30), (timer) {
  //     sendPing();
  //   });
  // }

  sendUserContent(ContentModel contentModel, String roomIdentifier) async {
    webSocketConnection.sendMessage("chat message", {
      'roomIdentifier': roomIdentifier,
      'text': contentModel.messageText,
      'senderId': contentModel.senderId,
      'receiverId': contentModel.receiverId,
      'receiverType': contentModel.receiverType.toString(),
      'messageId': contentModel.contentId,
      // "timestamp": DateTime.now().millisecondsSinceEpoch,
    });
  }

  sendGroupContent(ContentModel contentModel, List<String> receiverUsers,
      String senderAvatar, String senderName, String roomIdentifier) async {
    webSocketConnection.sendMessage("chat message", {
      'roomIdentifier': roomIdentifier,
      'text': contentModel.messageText,
      'senderId': contentModel.senderId,
      'senderAvatar': senderAvatar,
      'senderName': senderName,
      'receiverUsers': receiverUsers,
      'receiverId': contentModel.receiverId,
      'receiverType': contentModel.receiverType,
      'messageId': contentModel.contentId,
      // "timestamp": DateTime.now().millisecondsSinceEpoch,
    });
  }

  sendTyping(String senderName) async {
    webSocketConnection.sendMessage("typing", {
      'senderName': senderName,
    });
  }

  sendStopTyping(String senderId) async {
    webSocketConnection.sendMessage("stopTyping", {
      'senderId': senderId,
    });
  }

  sendJoinRoom(String roomIdentifier) async {
    webSocketConnection.sendMessage("joinRoom", {
      'roomIdentifier': roomIdentifier,
    });
  }

  sendAddOnlineUser(String userId, String categoryId) async {
    webSocketConnection.sendMessage("addOnlineUser", {
      'userId': userId,
      'categoryId': categoryId,
    });
  }

  // sendNewGroupChat(String userId, String categoryId) async {
  //   webSocketConnection.sendMessage("newChatGroup", {
  //     'chatGroup': userId,
  //     'usersInGroup': categoryId,
  //   });
  // }
}
