import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:messaging_core/core/env/constants.dart';

class Environment {
  static Future<void> initEnvironment() async {
    if (kIsProduction) {
      await dotenv.load(fileName: "production.env");
    } else if (kIsStage) {
      await dotenv.load(fileName: "stage.env");
    } else {
      await dotenv.load(fileName: "lib/develop.env");
    }
  }

  static String get apiBaseUrl {
    return dotenv.get("API_BASE_URL");
  }
  static String get websocketUrl {
    return dotenv.get("WEB_SOCKET_BASE_URL");
  }
}
