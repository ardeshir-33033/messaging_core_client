class WebsocketException implements Exception {
  WebsocketException();
}

class SocketTimeoutException extends WebsocketException{}

class UnknownException extends WebsocketException{}