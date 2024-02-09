import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:messaging_core/app/theme/app_colors.dart';
import 'package:messaging_core/app/theme/app_text_styles.dart';
import 'package:messaging_core/app/theme/constants.dart';
import 'package:messaging_core/app/widgets/icon_widget.dart';
import 'package:messaging_core/app/widgets/text_widget.dart';
import 'package:messaging_core/core/services/media_handler/voice_handler.dart';
import 'package:messaging_core/core/utils/extensions.dart';
import 'package:messaging_core/features/chat/presentation/widgets/voice_content_widget.dart';

class ConversationVoiceRecordingOptionWidget extends StatelessWidget {
  final RecordStateEnum recordState;
  final VoidCallback onPauseRecording;
  final VoidCallback onResumeRecording;
  final VoidCallback onSendVoiceMessage;
  final VoidCallback onDeleteRecording;

  const ConversationVoiceRecordingOptionWidget({
    Key? key,
    required this.recordState,
    required this.onResumeRecording,
    required this.onPauseRecording,
    required this.onSendVoiceMessage,
    required this.onDeleteRecording,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (recordState == RecordStateEnum.record) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          children: [
            const VoiceCounterWidget(
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        children: [
          // if (recordState == RecordStateEnum.pause) ...[
          //   Container(
          //     padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 4),
          //     decoration: BoxDecoration(
          //       color: const Color(0xffF3F4F8),
          //       borderRadius: BorderRadius.circular(16),
          //     ),
          //     child: ValueListenableBuilder2<String, AudioState>(
          //       first: VoiceHandler().currentPlayingAudioId,
          //       second: VoiceHandler().audioStateNotifier,
          //       builder: (context, selectedVoiceUrl, voiceState, child) => Row(
          //         children: [
          //           InkWell(
          //             onTap: () => onTapButton.call(
          //                 isSelectedVoice(selectedVoiceUrl), voiceState),
          //             child: VoiceButtonStateWidget(
          //               voiceState: voiceState,
          //               isSelectedVoice: isSelectedVoice(selectedVoiceUrl),
          //               isLoading: false,
          //               isCached: true,
          //             ),
          //           ),
          //           const SizedBox(
          //             width: 8,
          //           ),
          //           Expanded(
          //             child: SfSliderTheme(
          //               data: SfSliderThemeData(
          //                 activeTrackHeight: 3,
          //                 inactiveTrackHeight: 2,
          //                 trackCornerRadius: 4,
          //                 activeTrackColor: AppColors.primary1,
          //                 thumbStrokeWidth: 2,
          //                 thumbRadius: 6,
          //                 inactiveDividerStrokeColor: Color(0xffA8B1CF),
          //                 inactiveTickColor: Color(0xffA8B1CF),
          //                 inactiveTrackColor: Color(0xffA8B1CF),
          //                 thumbColor: AppColors.primary1,
          //               ),
          //               child: StreamBuilder(
          //                 stream: isSelectedVoice(selectedVoiceUrl)
          //                     ? VoiceHandler().player.positionStream
          //                     : Stream.value(0),
          //                 builder: (context, snapshot) {
          //                   double seek = 0.0;
          //                   if (isSelectedVoice(selectedVoiceUrl) &&
          //                       snapshot.data != null &&
          //                       snapshot.data is Duration) {
          //                     seek = (snapshot.data as Duration).inSeconds.toDouble();
          //                   }
          //                   return Column(
          //                     crossAxisAlignment: CrossAxisAlignment.start,
          //                     mainAxisAlignment: MainAxisAlignment.end,
          //                     children: [
          //                       Center(
          //                         heightFactor: 0.6,
          //                         child: SfSlider(
          //                           interval: 0.1,
          //                           value: seek,
          //                           max: VoiceHandler().seconds.value,
          //                           min: 0,
          //                           onChanged: (value) {
          //                             VoiceHandler().seek(value.toInt());
          //                           },
          //                         ),
          //                       ),
          //                     ],
          //                   );
          //                 },
          //               ),
          //             ),
          //           ),
          //           const VoiceCounterWidget(hasBlinking: false),
          //
          //         ],
          //       ),
          //     ),
          //   ),
          // ],
          // if (recordState == RecordStateEnum.lockRecord) ...[
          //   const Row(
          //     textDirection: TextDirection.ltr,
          //     children: [
          //       VoiceCounterWidget(
          //         hasBlinking: true,
          //       ),
          //       Spacer(),
          //     ],
          //   )
          // ],
          Row(
            textDirection: TextDirection.ltr,
            children: [
              VoiceCounterWidget(
                hasBlinking: recordState == RecordStateEnum.lockRecord,
              ),
              const Spacer(),
            ],
          ),
          const SizedBox(
            height: 8,
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
    return url == VoiceHandler().recordingVoiceId;
  }

  void onTapButton(bool isSelectedVoice, AudioState voiceState) {
    if (isSelectedVoice == false) {
      VoiceHandler().playRecordingVoice();
    } else {
      switch (voiceState) {
        case AudioState.paused:
          if (isSelectedVoice) {
            VoiceHandler().resumePlayer();
          } else {
            VoiceHandler().playRecordingVoice();
          }
          return;
        case AudioState.playing:
          VoiceHandler().pausePlayer();
          return;
        case AudioState.stopped:
          VoiceHandler().playRecordingVoice();
          return;
        case AudioState.loading:
          return;
      }
    }
  }
}

class VoiceCounterWidget extends StatelessWidget {
  final bool hasBlinking;

  const VoiceCounterWidget({
    Key? key,
    required this.hasBlinking,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 60,
      child: ValueListenableBuilder(
        valueListenable: VoiceHandler().milliSeconds,
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
