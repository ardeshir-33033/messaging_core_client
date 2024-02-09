import 'package:flutter/foundation.dart';

class HttpException implements Exception {
  final Object type;
  final String? error;

  HttpException(this.type, [this.error]) {
    // debugPrintStack(label: toString());
  }

  int get statusCode => 500;

  @override
  String toString() => error == null ? '$type' : '$type: ($error)';
}

class ForbiddenException extends HttpException {
  final String url;

  ForbiddenException(this.url, [String? error])
      : super(UnauthorisedException, error);

  @override
  String toString() => 'UnauthorisedException in $url';
}

class InvalidInputException extends HttpException {
  final String url;

  InvalidInputException(this.url, [String? error])
      : super(InvalidInputException, error);

  @override
  String toString() => 'InvalidInputException in $url';
}

class SocketException extends HttpException {
  final String url;

  SocketException(this.url, [String? error]) : super(SocketException, error);

  @override
  String toString() => 'SocketException in $url';
}

class NotFoundException extends HttpException {
  final String url;

  NotFoundException(this.url, [String? error])
      : super(NotFoundException, error);

  @override
  int get statusCode => 404;

  @override
  String toString() => 'NotFoundException in $url';
}

class TooManyRequestException extends HttpException {
  final String url;

  TooManyRequestException(this.url, [String? error])
      : super(TooManyRequestException, error);

  @override
  String toString() => 'TooManyRequestException in $url';
}

class ServerException extends HttpException {
  final String url;

  ServerException(this.url, [String? error]) : super(ServerException, error);

  @override
  String toString() => 'ServerException in $url';
}

class CancelRequestException extends HttpException {
  final String url;

  CancelRequestException(this.url, [String? error])
      : super(CancelRequestException, error);

  @override
  String toString() => 'CancelRequestException in $url';
}

class NotHandleException extends HttpException {
  final String url;

  NotHandleException(this.url, [String? error])
      : super(NotHandleException, error);

  @override
  String toString() => 'NotHandleException in $url';
}

class UnauthorisedException extends HttpException {
  final String url;

  UnauthorisedException(this.url, [String? error])
      : super(UnauthorisedException, error);

  @override
  String toString() => 'UnauthorisedException in $url';
}

class BadRequestException extends HttpException {
  final String url;
  final Map<String, dynamic> json;

  BadRequestException(this.url, this.json, [String? error])
      : super(BadRequestException, error);

  @override
  String toString() => 'BadRequestException in $url';
}
