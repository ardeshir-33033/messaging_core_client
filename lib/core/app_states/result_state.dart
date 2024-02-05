import 'package:get/get.dart';

class RequestStatus {
  Status status = Status.initial;
  String? _message;

  get message => _message ?? 'خطایی رخ داده است';

  set message(m) {
    status = Status.error;
    _message = m;
  }

  @override
  bool operator ==(other) {
    if (other is Status) {
      return other == other;
    }
    return false;
  }

  @override
  int get hashCode {
    return status.hashCode;
  }

  void loading() {
    status = Status.loading;
  }

  void success({String? message}) {
    status = Status.success;
    if (message != null) {
      // MessageBar().showMessage(message, type: MessageType.SUCCESS);
    }
  }

  void initial() {
    status = Status.initial;
  }

  void error(String message,
      {bool showMessage = true, bool showFromMessage = false}) {
    status = Status.error;
    // _message = message;
    if (showFromMessage) {
      _message = message;
    } else {
      _message = "errorCode".tr;
    }
  }

  void clear() {
    status = Status.initial;
    _message = null;
  }
}

enum Status {
  initial,
  loading,
  success,
  error,
}
