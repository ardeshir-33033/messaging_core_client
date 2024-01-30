import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:messaging_core/core/env/constants.dart';

class Environment {
  static Future<void> initEnvironment() async {
    if (kIsProduction) {
      await dotenv.load(fileName: "production.env");
    } else if (kIsStage) {
      await dotenv.load(fileName: "stage.env");
    } else {
      await dotenv.load(fileName: "develop.env");
    }
  }
}
