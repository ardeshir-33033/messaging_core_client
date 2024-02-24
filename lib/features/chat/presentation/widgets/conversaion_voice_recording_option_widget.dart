import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:messaging_core/app/theme/app_colors.dart';
import 'package:messaging_core/app/theme/app_text_styles.dart';
import 'package:messaging_core/app/theme/constants.dart';
import 'package:messaging_core/app/widgets/icon_widget.dart';
import 'package:messaging_core/app/widgets/text_widget.dart';
import 'package:messaging_core/core/services/media_handler/voice_handler.dart';
import 'package:messaging_core/core/utils/extensions.dart';
import 'package:messaging_core/features/chat/presentation/manager/record_voice_controller.dart';
import 'package:messaging_core/features/chat/presentation/widgets/review_voice_message_widget.dart';
import 'package:messaging_core/features/chat/presentation/widgets/voice_content_widget.dart';

class ConversationVoiceRecordingOptionWidget extends StatelessWidget {
  final RecordStateEnum recordState;
  final VoidCallback onPauseRecording;
  final VoidCallback onResumeRecording;
  final VoidCallback onSendVoiceMessage;
  final VoidCallback onDeleteRecording;

  ConversationVoiceRecordingOptionWidget({
    Key? key,
    required this.recordState,
    required this.onResumeRecording,
    required this.onPauseRecording,
    required this.onSendVoiceMessage,
    required this.onDeleteRecording,
  }) : super(key: key);

  RecordVoiceController voiceController = Get.find<RecordVoiceController>();

  @override
  Widget build(BuildContext context) {
    if (recordState == RecordStateEnum.record) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          children: [
            VoiceCounterWidget(
              hasBlinking: true,
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.arrow_back,
                    color: Color(0xff687296),
                    size: 16,
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  AnimatedTextKit(
                    repeatForever: true,
                    animatedTexts: [
                      ColorizeAnimatedText(
                        tr(context).slideToCancel,
                        textStyle:
                            AppTextStyles.overline2.copyWith(fontSize: 12),
                        speed: const Duration(milliseconds: 200),
                        colors: [
                          const Color(0xff687296),
                          Colors.black,
                          Colors.white,
                        ],
                      ),
                    ],
                    isRepeatingAnimation: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }
    if (recordState == RecordStateEnum.review) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(26),
          color: AppColors.primary1,
        ),
        child: const Row(
          children: [
            IconWidget(
              icon: Assets.trashReviewVoice,
              size: 30,
            ),
            Expanded(child: ReviewVoiceMessage()),
            IconWidget(
              icon: Assets.sendReviewVoice,
              size: 30,
            ),
          ],
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        children: [
          Row(
            textDirection: TextDirection.ltr,
            children: [
              VoiceCounterWidget(
                hasBlinking: recordState == RecordStateEnum.lockRecord,
              ),
              const Spacer(),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            textDirection: TextDirection.ltr,
            children: [
              IconWidget(
                icon: Assets.trashMic,
                iconColor: AppColors.primary1,
                size: 24,
                width: 32,
                height: 32,
                onPressed: onDeleteRecording,
              ),
              IconWidget(
                onPressed: () {
                  if (recordState == RecordStateEnum.lockRecord) {
                    onPauseRecording.call();
                  } else {
                    onResumeRecording.call();
                  }
                },
                icon: recordState == RecordStateEnum.lockRecord
                    ? Assets.pause
                    : Assets.micFillIcon,
                iconColor: const Color(0xffEB5757),
                boxShape: BoxShape.circle,
                size: 24,
                width: 32,
                height: 32,
              ),
              IconWidget(
                onPressed: onSendVoiceMessage,
                icon: Assets.sendVoice,
                backgroundColor: AppColors.primary1,
                boxShape: BoxShape.circle,
                size: 24,
                width: 32,
                height: 32,
              ),
            ],
          )
        ],
      ),
    );
  }

  bool isSelectedVoice(String url) {
    return url == voiceController.recordingVoiceId;
  }

  void onTapButton(bool isSelectedVoice, AudioState voiceState) {
    if (isSelectedVoice == false) {
      voiceController.playRecordingVoice();
    } else {
      switch (voiceState) {
        case AudioState.paused:
          if (isSelectedVoice) {
            voiceController.resumePlayer();
          } else {
            voiceController.playRecordingVoice();
          }
          return;
        case AudioState.playing:
          voiceController.pausePlayer();
          return;
        case AudioState.stopped:
          voiceController.playRecordingVoice();
          return;
        case AudioState.loading:
          return;
      }
    }
  }
}

class VoiceCounterWidget extends StatelessWidget {
  final bool hasBlinking;

  VoiceCounterWidget({
    Key? key,
    required this.hasBlinking,
  }) : super(key: key);

  RecordVoiceController voiceController = Get.find<RecordVoiceController>();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 60,
      child: ValueListenableBuilder(
        valueListenable: voiceController.milliSeconds,
        builder: (context, milliSeconds, child) => Row(
          children: [
            if (hasBlinking) ...[
              AnimatedContainer(
                height: 5,
                width: 5,
                duration: const Duration(milliseconds: 100),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: (milliSeconds ~/ 1000).isOdd
                      ? const Color(0xffFF4B55)
                      : const Color(0xffA8B1CF),
                ),
              )
            ],
            const SizedBox(
              width: 4,
            ),
            TextWidget(
              (milliSeconds ~/ 1000).timeFormat(),
              style: AppTextStyles.overline1.copyWith(
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
