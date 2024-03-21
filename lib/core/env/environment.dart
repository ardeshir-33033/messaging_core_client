import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:messaging_core/core/env/constants.dart';

class Environment {
  static Future<void> initEnvironment() async {
    if (kIsProduction) {
      await dotenv.load(fileName: "production.env");
    } else if (kIsStage) {
      await dotenv.load(fileName: "stage.env");
    } else {
      // await dotenv.load(fileName: "lib/develop.env");
    }
  }

  static String get apiBaseUrl {
    return "https://zoomiran.com/api/v1";
    // return dotenv.get("API_BASE_URL");
  }

  static String get websocketUrl {
    return "https://andoonya.com";
    // return dotenv.get("WEB_SOCKET_BASE_URL");
  }
}
