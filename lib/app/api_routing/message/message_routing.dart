import 'package:messaging_core/core/env/environment.dart';

class MessageRouting {
  static const initial = "messages";

  static final showMessages = "${Environment.apiBaseUrl}/$initial/show";
  static final sendMessages = "${Environment.apiBaseUrl}/$initial/send";
  static String editMessages(String messageId) {
    return "${Environment.apiBaseUrl}/$initial/update-message/$messageId";
  }

  static String deleteMessages(String messageId) {
    return "${Environment.apiBaseUrl}/$initial/$messageId";
  }

  static final agoraToken =
      "${Environment.apiBaseUrl}/$initial/generate-agora-token";
  static final updateRead = "${Environment.apiBaseUrl}/$initial/update";
}
