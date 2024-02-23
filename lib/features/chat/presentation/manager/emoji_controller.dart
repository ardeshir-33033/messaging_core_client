import 'package:get/get.dart';
import 'package:messaging_core/features/chat/presentation/manager/record_voice_controller.dart';

class EmojiController extends GetxController {
  bool emojiShowing = false;
  bool showSendButton = false;

  changeEmojiState() {
    emojiShowing = !emojiShowing;
    update(["emoji"]);
  }

  stopShowingEmoji() {
    if (emojiShowing == true) {
      changeEmojiState();
    }
  }

  handleShowSendButton() {
    if (!showSendButton) {
      showSendButton = true;
      RecordVoiceController voiceController = Get.find<RecordVoiceController>();
      voiceController.update();
      update(["send"]);
    }
  }

  handleNotShowSendButton() {
    if (showSendButton) {
      showSendButton = false;
      RecordVoiceController voiceController = Get.find<RecordVoiceController>();
      voiceController.update();
    }
  }
}
