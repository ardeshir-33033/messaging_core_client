import 'package:flutter/material.dart';
import 'package:messaging_core/core/utils/extensions.dart';
import 'package:messaging_core/main.dart';

class SystemException implements Exception {
  final String? message;

  SystemException(this.message) {
    debugPrintStack(label: toString());
  }

  @override
  String toString() => message ?? "";
}

class PermissionException extends SystemException {
  PermissionException(String message) : super(message);
}

class DefaultException extends SystemException {
  DefaultException()
      : super("Something Went Wrong");
}
