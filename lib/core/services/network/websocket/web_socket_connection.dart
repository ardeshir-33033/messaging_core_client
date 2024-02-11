import 'dart:async';
import 'package:messaging_core/core/app_states/app_global_data.dart';
import 'package:messaging_core/core/env/environment.dart';
import 'package:messaging_core/features/chat/domain/entities/content_model.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';

class WebSocketConnection {
  IO.Socket? channel;
  bool isConnected = false;

  void initState() {
    initChannel();
  }

  void resetState() async {
    channel = null;
    isConnected = false;
    // notifyListeners();
  }

  Future initChannel() async {
    // Map<String , dynamic>  headers = HttpHeader.setHeaders(HttpHeaderType.webSocket);

    channel = IO.io(Environment.websocketUrl,
        IO.OptionBuilder().setTransports(["websocket"]).build());
    channel?.onConnect((data) {
      isConnected = true;
      print("-----------------   Successful Connection     -----------------");
    });

    channel?.onConnectError((data) {
      print("-----------------   Connection Error $data     -----------------");
    });

    channel?.onDisconnect((data) {
      isConnected = false;
      print("-----------------   Disconnected     -----------------");
    });

    channel?.on("chat message", (data) {
      print(data);
      if (data["senderId"] != AppGlobalData.userId) {

      }
    });

    channel?.on("notification", (data) {
      print(data);
    });

    channel?.on("userTyping", (data) {
      print(data);
    });
    channel?.on("userStoppedTyping", (data) {
      print(data);
    });
    channel?.on("ChatGroupChange", (data) {
      print(data);
    });

    channel?.on("addOnlineUser", (data) {
      print(data);
    });
  }

  void sendMessage(String event, dynamic payload) {
    if (isConnected) {
      channel?.emit(event, payload);
    }
  }

  void closeConnection() {
    channel?.close();
    channel = null;
    isConnected = false;
  }

  Future retryConnection() async {
    if (isConnected) return;
    await initChannel();
  }
}
