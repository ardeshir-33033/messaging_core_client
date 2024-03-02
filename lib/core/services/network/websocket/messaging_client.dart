import 'dart:convert';

import 'package:messaging_core/core/app_states/app_global_data.dart';
import 'package:messaging_core/core/services/network/websocket/web_socket_connection.dart';
import 'package:messaging_core/features/chat/data/models/call_model.dart';
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
      'messageType': contentModel.contentType.toString()
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

  sendSignal(List<int> ids, CallModel callModel) async {
    webSocketConnection.sendMessage("signaling", {
      'targetUserIds': ids,
      'categoryId': AppGlobalData.categoryId,
      'signalingData': jsonEncode(callModel.toJson()),
    });
  }

  sendTyping() async {
    webSocketConnection.sendMessage("typing", {
      'senderName': AppGlobalData.userName,
      'senderId': AppGlobalData.userId,
    });
  }

  sendStopTyping() async {
    webSocketConnection.sendMessage("stopTyping", {
      'senderId': AppGlobalData.userId,
    });
  }

  sendJoinRoom(String roomIdentifier) async {
    webSocketConnection.sendMessage("joinRoom", {
      roomIdentifier,
    });
  }

  sendAddOnlineUser() async {
    webSocketConnection.sendMessage("addOnlineUser", {
      'userId': AppGlobalData.userId,
      'categoryId': AppGlobalData.categoryId,
    });
  }

  sendLeaveRoomEvent(String roomIdentifier) async {
    webSocketConnection.sendMessage("leaveRoom", {roomIdentifier});
  }

  // sendNewGroupChat(String userId, String categoryId) async {
  //   webSocketConnection.sendMessage("newChatGroup", {
  //     'chatGroup': userId,
  //     'usersInGroup': categoryId,
  //   });
  // }
}
