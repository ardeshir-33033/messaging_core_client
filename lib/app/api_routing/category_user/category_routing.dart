import 'package:messaging_core/core/env/environment.dart';

class CategoryRouting {
  static const initial = "category-users";
  static final usersInCategory = "${Environment.apiBaseUrl}/$initial";
}
