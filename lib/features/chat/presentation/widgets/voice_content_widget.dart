import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:messaging_core/app/theme/app_colors.dart';
import 'package:messaging_core/app/theme/app_text_styles.dart';
import 'package:messaging_core/app/widgets/custom_value_listenable.dart';
import 'package:messaging_core/app/widgets/icon_widget.dart';
import 'package:messaging_core/app/widgets/loading_widget.dart';
import 'package:messaging_core/app/widgets/text_widget.dart';
import 'package:messaging_core/core/enums/file_type.dart';
import 'package:messaging_core/core/services/media_handler/voice_handler.dart';
import 'package:messaging_core/core/utils/extensions.dart';
import 'package:messaging_core/core/utils/utils.dart';
import 'package:messaging_core/features/chat/domain/entities/content_model.dart';
import 'package:messaging_core/features/chat/domain/entities/voice_content_payload_model.dart';
import 'package:messaging_core/features/chat/presentation/manager/record_voice_controller.dart';
import 'package:messaging_core/features/chat/presentation/widgets/media_progress_widget.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:syncfusion_flutter_core/theme.dart';

enum AudioState { paused, playing, loading, stopped }

// class VoiceContentWidget extends StatefulWidget {
//   final ContentModel contentModel;
//   final bool isUploading;
//   final String contentId;
//   final String senderName;
//   final VoiceContentPayloadModel contentPayload;
//
//   const VoiceContentWidget({
//     required this.contentModel,
//     required this.isUploading,
//     required this.contentId,
//     required this.contentPayload,
//     super.key,
//     required this.senderName,
//   });
//
//   @override
//   State<VoiceContentWidget> createState() => _VoiceContentWidgetState();
// }
//
// class _VoiceContentWidgetState extends State<VoiceContentWidget> {
//   late CancelToken cancelToken;
//   bool _isCached = false;
//   bool _isDownloading = false;
//   double currentPositionInMS = 0;
//   RecordVoiceController voiceController = Get.find<RecordVoiceController>();
//
//
//   @override
//   void initState() {
//     super.initState();
//     checkCachingFile();
//     cancelToken = CancelToken();
//   }
//
//   @override
//   void didUpdateWidget(covariant VoiceContentWidget oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     if (oldWidget.contentPayload.url != widget.contentPayload.url) {
//       _isCached = false;
//       currentPositionInMS = 0;
//       setState(() {});
//       checkCachingFile();
//     }
//   }
//
//   String get fileVoicePath =>
//       "${widget.contentModel.contentId}.${widget.contentPayload.extension}";
//
//   Future<void> checkCachingFile() async {
//     getCachedFile(
//       "${widget.contentId}.${widget.contentPayload.extension}",
//       FileType.audio,
//     ).then((value) {
//       if (value != null) {
//         _isCached = true;
//         setState(() {});
//       }
//     });
//   }
//
//   void changeSeek(double value, bool isSelectedVoice) {
//     setState(() {
//       currentPositionInMS = value;
//     });
//     if (isSelectedVoice) {
//       voiceController.seek(currentPositionInMS.toInt());
//     }
//   }
//
//   void changeLoadingState(bool state) {
//     setState(() {
//       _isDownloading = state;
//     });
//   }
//
//   Future<void> downloadMedia() async {
//     changeLoadingState(true);
//     // _isCached = await VoiceHandler().downloadMedia(
//     //   widget.contentPayload.url,
//     //   widget.contentId,
//     //   FileType.audio,
//     //   widget.contentPayload.extension!,
//     //   cancelToken: cancelToken,
//     // );
//     changeLoadingState(false);
//   }
//
//   Future<void> playVoice() async {
//     // await VoiceHandler().playVoiceMessage(
//     //   CurrentPlayingAudio(
//     //     audioKey: fileVoicePath,
//     //     title: widget.senderName,
//     //   ),
//     //   seek: currentPositionInMS.toInt(),
//     // );
//   }
//
//   Future<void> pauseVoice() async {
//     await voiceController.pausePlayer();
//     setState(() {});
//   }
//
//   Future<void> resumeVoice() async {
//     await voiceController.resumePlayer();
//     setState(() {});
//   }
//
//   bool isSelectedVoice(CurrentPlayingAudio? playingAudio) {
//     if (playingAudio == null) return false;
//     return playingAudio.audioKey == fileVoicePath;
//   }
//
//   bool isLoadingState(bool isSelected, AudioState audioState) {
//     return (_isDownloading ||
//         widget.isUploading ||
//         (audioState == AudioState.loading && isSelected));
//   }
//
//   int get durationInSeconds {
//     return widget.contentPayload.durationInMilliSeconds ?? 0 ~/ 1000;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return ValueListenableBuilder2<CurrentPlayingAudio?, AudioState>(
//       first: VoiceHandler().currentPlayingAudio,
//       second: VoiceHandler().audioStateNotifier,
//       builder: (context, currentPlayingAudio, voiceState, child) => Row(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Center(
//             child: InkWell(
//               onTap: () => onTapButton.call(
//                   isSelectedVoice(currentPlayingAudio), voiceState),
//               child: Container(
//                 height: 40,
//                 width: 40,
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   border: isLoadingState(
//                           isSelectedVoice(currentPlayingAudio), voiceState)
//                       ? null
//                       : Border.all(
//                           color: AppColors.primary1,
//                           width: 3,
//                         ),
//                 ),
//                 child: Center(
//                   child: Builder(
//                     builder: (context) {
//                       return VoiceButtonStateWidget(
//                         voiceState: voiceState,
//                         isSelectedVoice: isSelectedVoice(currentPlayingAudio),
//                         isLoading: _isDownloading || widget.isUploading,
//                         isCached: _isCached,
//                         contentId: widget.contentId,
//                         onCancel: () {
//                           if (_isDownloading) {
//                             cancelToken.cancel();
//                             changeLoadingState(false);
//                           } else {
//                             // VoiceHandler()
//                             //     .cancelUploadingContent(widget.contentModel);
//                           }
//                         },
//                       );
//                     },
//                   ),
//                 ),
//               ),
//             ),
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
//                 inactiveDividerStrokeColor: const Color(0xffA8B1CF),
//                 inactiveTickColor: const Color(0xffA8B1CF),
//                 inactiveTrackColor: const Color(0xffA8B1CF),
//                 thumbColor: AppColors.primary1,
//               ),
//               child: StreamBuilder(
//                 stream: isSelectedVoice(currentPlayingAudio)
//                     ? VoiceHandler().player.positionStream
//                     : Stream.value(0),
//                 builder: (context, snapshot) {
//                   if (isSelectedVoice(currentPlayingAudio) &&
//                       snapshot.data != null &&
//                       snapshot.data is Duration) {
//                     currentPositionInMS =
//                         (snapshot.data as Duration).inMilliseconds.toDouble();
//                   }
//                   return Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     mainAxisAlignment: MainAxisAlignment.end,
//                     children: [
//                       Center(
//                         heightFactor: 0.6,
//                         child: SfSlider(
//                           value: currentPositionInMS,
//                           max: widget.contentPayload.durationInMilliSeconds,
//                           min: 0,
//                           onChanged: (value) {
//                             changeSeek(
//                                 value, isSelectedVoice(currentPlayingAudio));
//                           },
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                         child: TextWidget(
//                           isSelectedVoice(currentPlayingAudio)
//                               ? (currentPositionInMS ~/ 1000).timeFormat()
//                               : durationInSeconds.timeFormat(),
//                           style: AppTextStyles.overline2.copyWith(
//                               fontSize: 8, color: const Color(0xff828FBB)),
//                         ),
//                       ),
//                     ],
//                   );
//                 },
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   void onTapButton(bool isSelectedVoice, AudioState voiceState) {
//     if (widget.isUploading) {
//       // VoiceHandler().cancelUploadingContent(widget.contentModel);
//     } else if (_isDownloading) {
//       cancelToken.cancel();
//       cancelToken = CancelToken();
//     } else if (_isCached == false) {
//       downloadMedia();
//       return;
//     } else if (isSelectedVoice == false) {
//       playVoice();
//     } else {
//       switch (voiceState) {
//         case AudioState.paused:
//           if (isSelectedVoice) {
//             resumeVoice();
//           } else {
//             playVoice();
//           }
//           return;
//         case AudioState.playing:
//           pauseVoice();
//           return;
//         case AudioState.loading:
//           return;
//         case AudioState.stopped:
//           playVoice();
//           return;
//       }
//     }
//   }
// }
//
// class VoiceButtonStateWidget extends StatelessWidget {
//   final bool isSelectedVoice;
//   final AudioState voiceState;
//   final bool isLoading;
//   final bool isCached;
//   final String contentId;
//   final VoidCallback onCancel;
//
//   const VoiceButtonStateWidget({
//     Key? key,
//     required this.isSelectedVoice,
//     required this.voiceState,
//     required this.isLoading,
//     required this.isCached,
//     required this.contentId,
//     required this.onCancel,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     if (isLoading) {
//       return MediaProgressWidget<VoiceHandler>(
//         contentId: contentId,
//         handler: VoiceHandler(),
//         onCancel: onCancel,
//       );
//     }
//     if (isCached == false) {
//       return const IconWidget(
//         icon: Icons.arrow_downward_rounded,
//         iconColor: AppColors.primary1,
//       );
//     }
//     if (isSelectedVoice == false) {
//       return const IconWidget(
//         icon: Icons.play_arrow,
//         iconColor: AppColors.primary1,
//         size: 20,
//       );
//     }
//     return switch (voiceState) {
//       AudioState.loading => const Padding(
//           padding: EdgeInsets.all(6.0),
//           child: LoadingWidget(
//             strokeWidth: 3,
//             color: AppColors.primary1,
//           ),
//         ),
//       AudioState.playing => const IconWidget(
//           icon: Icons.pause,
//           size: 20,
//           iconColor: AppColors.primary1,
//         ),
//       AudioState.paused => const IconWidget(
//           icon: Icons.play_arrow,
//           size: 20,
//           iconColor: AppColors.primary1,
//         ),
//       AudioState.stopped => const IconWidget(
//           icon: Icons.play_arrow,
//           size: 20,
//           iconColor: AppColors.primary1,
//         )
//     };
//   }
// }
