
import 'dart:io';

abstract class Failure  {
  final String? message;
  final dynamic error;

  const Failure({
    this.error,
    this.message,
  });
}

class ServerFailure extends Failure {
  final int? statusCode;

  const ServerFailure({
    this.statusCode,
    required String message,
    required HttpException exception,
  }) : super(message: message, error: exception);
}

class CacheFailure extends Failure {}

class PermissionFailure extends Failure {}
