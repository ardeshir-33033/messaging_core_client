import 'package:flutter/material.dart';
import 'package:messaging_core/app/theme/app_colors.dart';
import 'package:messaging_core/app/theme/app_text_styles.dart';
import 'package:messaging_core/app/widgets/custom_value_listenable.dart';
import 'package:messaging_core/app/widgets/text_widget.dart';
import 'package:messaging_core/core/services/media_handler/voice_handler.dart';
import 'package:messaging_core/core/utils/extensions.dart';
import 'package:messaging_core/features/chat/presentation/widgets/voice_content_widget.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:syncfusion_flutter_core/theme.dart';

class ReviewVoiceMessage extends StatefulWidget {
  const ReviewVoiceMessage({super.key});

  @override
  State<ReviewVoiceMessage> createState() => _ReviewVoiceMessageState();
}

class _ReviewVoiceMessageState extends State<ReviewVoiceMessage> {
  double currentPositionInMS = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  Container();
    //   ValueListenableBuilder2<CurrentPlayingAudio?, AudioState>(
    //   first: VoiceHandler().currentPlayingAudio,
    //   second: VoiceHandler().audioStateNotifier,
    //   builder: (context, currentPlayingAudio, voiceState, child) => Row(
    //     crossAxisAlignment: CrossAxisAlignment.center,
    //     children: [
    //       Center(
    //         child: InkWell(
    //           onTap: () => onTapButton.call(
    //               isSelectedVoice(currentPlayingAudio), voiceState),
    //           child: Container(
    //             height: 40,
    //             width: 40,
    //             decoration: BoxDecoration(
    //               shape: BoxShape.circle,
    //               border: isLoadingState(
    //                       isSelectedVoice(currentPlayingAudio), voiceState)
    //                   ? null
    //                   : Border.all(
    //                       color: AppColors.primary1,
    //                       width: 3,
    //                     ),
    //             ),
    //             child: Center(
    //               child: Builder(
    //                 builder: (context) {
    //                   return VoiceButtonStateWidget(
    //                     voiceState: voiceState,
    //                     isSelectedVoice: isSelectedVoice(currentPlayingAudio),
    //                     isLoading: false,
    //                     isCached: false,
    //                     contentId: "widget.contentId",
    //                     onCancel: () {},
    //                   );
    //                 },
    //               ),
    //             ),
    //           ),
    //         ),
    //       ),
    //       Expanded(
    //         child: SfSliderTheme(
    //           data: SfSliderThemeData(
    //             activeTrackHeight: 3,
    //             inactiveTrackHeight: 2,
    //             trackCornerRadius: 4,
    //             activeTrackColor: AppColors.primary1,
    //             thumbStrokeWidth: 2,
    //             thumbRadius: 6,
    //             inactiveDividerStrokeColor: const Color(0xffA8B1CF),
    //             inactiveTickColor: const Color(0xffA8B1CF),
    //             inactiveTrackColor: const Color(0xffA8B1CF),
    //             thumbColor: AppColors.primary1,
    //           ),
    //           child: StreamBuilder(
    //             stream: isSelectedVoice(currentPlayingAudio)
    //                 ? VoiceHandler().player.positionStream
    //                 : Stream.value(0),
    //             builder: (context, snapshot) {
    //               if (isSelectedVoice(currentPlayingAudio) &&
    //                   snapshot.data != null &&
    //                   snapshot.data is Duration) {
    //                 currentPositionInMS =
    //                     (snapshot.data as Duration).inMilliseconds.toDouble();
    //               }
    //               return Column(
    //                 crossAxisAlignment: CrossAxisAlignment.start,
    //                 mainAxisAlignment: MainAxisAlignment.end,
    //                 children: [
    //                   Center(
    //                     heightFactor: 0.6,
    //                     child: SfSlider(
    //                       value: currentPositionInMS,
    //                       max: cont.recordedFileDuration,
    //                       min: 0,
    //                       onChanged: (value) {
    //                         changeSeek(
    //                             value, isSelectedVoice(currentPlayingAudio));
    //                       },
    //                     ),
    //                   ),
    //                   Padding(
    //                     padding: const EdgeInsets.symmetric(horizontal: 16.0),
    //                     child: TextWidget(
    //                       isSelectedVoice(currentPlayingAudio)
    //                           ? (currentPositionInMS ~/ 1000).timeFormat()
    //                           : durationInSeconds.timeFormat(),
    //                       style: AppTextStyles.overline2.copyWith(
    //                           fontSize: 8, color: const Color(0xff828FBB)),
    //                     ),
    //                   ),
    //                 ],
    //               );
    //             },
    //           ),
    //         ),
    //       ),
    //     ],
    //   ),
    // );
  }

  // void onTapButton(bool isSelectedVoice, AudioState voiceState) {
  //   if (isSelectedVoice == false) {
  //     playVoice();
  //   } else {
  //     switch (voiceState) {
  //       case AudioState.paused:
  //         if (isSelectedVoice) {
  //           resumeVoice();
  //         } else {
  //           playVoice();
  //         }
  //         return;
  //       case AudioState.playing:
  //         pauseVoice();
  //         return;
  //       case AudioState.loading:
  //         return;
  //       case AudioState.stopped:
  //         playVoice();
  //         return;
  //     }
  //   }
  // }

  // Future<void> playVoice() async {
  //   await VoiceHandler().playVoiceMessage(VoiceHandler().recordedFilePath!
  //       // seek: currentPositionInMS.toInt(),
  //       );
  // }
  //
  // Future<void> pauseVoice() async {
  //   await VoiceHandler().pausePlayer();
  //   setState(() {});
  // }
  //
  // Future<void> resumeVoice() async {
  //   await voice.resumePlayer();
  //   setState(() {});
  // }
  //
  // bool isSelectedVoice(CurrentPlayingAudio? playingAudio) {
  //   if (playingAudio == null) return false;
  //   return VoiceHandler().recordedFilePath == "fileVoicePath";
  // }
  //
  // bool isLoadingState(bool isSelected, AudioState audioState) {
  //   return ((audioState == AudioState.loading && isSelected));
  // }
  //
  // void changeSeek(double value, bool isSelectedVoice) {
  //   setState(() {
  //     currentPositionInMS = value;
  //   });
  //   if (isSelectedVoice) {
  //     VoiceHandler().seek(currentPositionInMS.toInt());
  //   }
  // }
  //
  // int get durationInSeconds {
  //   return VoiceHandler().recordedFileDuration! ~/ 1000;
  // }
}
