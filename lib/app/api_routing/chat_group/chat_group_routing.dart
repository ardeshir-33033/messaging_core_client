import 'package:messaging_core/core/env/environment.dart';

class ChatGroupRouting {
  static const initial = "chatgroups";
  static const path = "category";

  static String groupChatsInCategory(int category) {
    return "${Environment.apiBaseUrl}/$initial/$path/$category";
  }

  static String editGroup(int categoryId) {
    return "${Environment.apiBaseUrl}/$initial/$categoryId";
  }

  static final String createChat = "${Environment.apiBaseUrl}/$initial";
}
