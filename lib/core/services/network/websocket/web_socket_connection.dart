import 'dart:async';
import 'package:messaging_core/core/env/environment.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';

class WebSocketConnection {
  IO.Socket? channel;
  bool isConnected = false;

  void initState() {}

  void resetState() async {
    channel = null;
    isConnected = false;
    // notifyListeners();
  }

  Future initChannel() async {
    // Map<String , dynamic>  headers = HttpHeader.setHeaders(HttpHeaderType.webSocket);

    channel = IO.io(Environment.websocketUrl);
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
    });

    channel?.on("chat message", (data) {
      print(data);
    });

    channel?.on("userTyping", (data) {
      print(data);
    });
    channel?.on("userStoppedTyping", (data) {
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
