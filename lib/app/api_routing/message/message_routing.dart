import 'package:messaging_core/core/env/environment.dart';

class MessageRouting {
  static const initial = "messages";

  static final showMessages = "${Environment.apiBaseUrl}/$initial/show";
}
