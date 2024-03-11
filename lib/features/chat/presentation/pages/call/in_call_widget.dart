// import 'dart:async';
// import 'package:expandable_bottom_sheet/expandable_bottom_sheet.dart';
// import 'package:flutter/material.dart';
// import 'package:messaging_core/app/theme/app_colors.dart';
// import 'package:messaging_core/app/theme/app_text_styles.dart';
// import 'package:messaging_core/app/theme/constants.dart';
// import 'package:messaging_core/app/widgets/text_widget.dart';
// import 'package:messaging_core/core/utils/extensions.dart';
// import 'package:messaging_core/core/utils/utils.dart';
// import 'package:messaging_core/features/chat/presentation/manager/call_controller.dart';
// import 'package:messaging_core/features/chat/presentation/pages/call/audio-call-widget.dart';
// import 'package:messaging_core/features/chat/presentation/widgets/agora_widgets/agora_custom_buttons.dart';
// import 'package:messaging_core/features/chat/presentation/widgets/agora_widgets/agora_video_pinngle_buttons.dart';
// import 'package:messaging_core/main.dart';
//
// class InCallPage extends StatefulWidget {
//   const InCallPage({super.key, required this.controller});
//
//   final CallController controller;
//
//   @override
//   State<InCallPage> createState() => _InCallPageState();
// }
//
// class _InCallPageState extends State<InCallPage> {
//   GlobalKey<ExpandableBottomSheetState> key = GlobalKey();
//   final Stopwatch _stopwatch = Stopwatch();
//   Timer? _timer;
//
//   @override
//   void initState() {
//     super.initState();
//
//     postFrameCallback(() {
//       startStopwatch();
//       Future.delayed(const Duration(milliseconds: 200), () {
//         key.currentState!.expand();
//       });
//     });
//   }
//
//   @override
//   void dispose() {
//     // TODO: implement dispose
//     super.dispose();
//   }
//
//   String get stopwatchText {
//     Duration timeElapsed = _stopwatch.elapsed;
//     int hours = timeElapsed.inHours;
//     int minutes = timeElapsed.inMinutes.remainder(60);
//     int seconds = timeElapsed.inSeconds.remainder(60);
//
//     return '$hours:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
//   }
//
//   void startStopwatch() {
//     if (!_stopwatch.isRunning) {
//       _stopwatch.start();
//       _timer = Timer.periodic(const Duration(seconds: 1), (_) {
//         setState(() {});
//       });
//     }
//   }
//
//   void stopStopwatch() {
//     if (_stopwatch.isRunning) {
//       _stopwatch.stop();
//       _timer?.cancel();
//       setState(() {});
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       bottom: false,
//       top: false,
//       child: ExpandableBottomSheet(
//         key: key,
//         background: Stack(
//           alignment: Alignment.center,
//           fit: StackFit.expand,
//           children: [
//             // AgoraVideoViewer(
//             //   client: widget.controller.client!,
//             //   layoutType: Layout.oneToOne,
//             //   enableHostControls: true,
//             //   disabledVideoWidget:
//             //       AudioCallWidget(controller: widget.controller),
//             // ),
//             ValueListenableBuilder(
//                 valueListenable: widget.controller.client!.sessionController,
//                 builder: (context, counter, widgetx) {
//                   return Positioned(
//                     top: 100,
//                     child: widget.controller.isOpponentVideoDisabled()
//                         ? Column(
//                             children: [
//                               Container(
//                                 padding: const EdgeInsets.all(8),
//                                 child: Text("name"
//                                     // widget.controller.profile == null
//                                     //     ? (widget.controller.opponentId == null
//                                     //         ? ''
//                                     //         : widget.controller.opponentId!
//                                     //             .midEllipsis())
//                                     //     : widget
//                                     //         .controller.profile!.displayName,
//                                     // style: AppTextStyles.overline.copyWith(
//                                     //     color: AppColors.primaryWhite)
//                                     ),
//                               ),
//                               const SizedBox(
//                                 height: 20,
//                               ),
//                               TextWidget(
//                                 _stopwatch.isRunning ? stopwatchText : '',
//                                 style: const TextStyle(
//                                     color: AppColors.primaryWhite),
//                               )
//                             ],
//                           )
//                         : const SizedBox(),
//                   );
//                 }),
//           ],
//         ),
//         persistentHeader: Container(
//           height: 50,
//           color: const Color(0xFF1E1E1E).withOpacity(0.5),
//           child: Center(
//             child: Container(
//               width: 25,
//               height: 4,
//               decoration: BoxDecoration(
//                 color: const Color(0xffDADDEB),
//                 borderRadius: BorderRadius.circular(1000),
//               ),
//             ),
//           ),
//         ),
//         expandableContent: Container(
//           height: 150,
//           color: const Color(0xFF1E1E1E).withOpacity(0.5),
//           child: Column(
//             children: [
//               AgoraVideoPinngleButtons(
//                 autoHideButtons: true,
//                 client: widget.controller.client!,
//                 enabledButtons: const [
//                   // BuiltInButtons.callEnd,
//                   // BuiltInButtons.switchCamera,
//                   // BuiltInButtons.toggleMic,
//                 ],
//                 buttonAlignment: Alignment.center,
//                 disconnectButtonChild: AgoraCustomButton(
//                     assetIcon: Assets.closeAgora,
//                     color: const Color(0xFFEB5757),
//                     padding: 20,
//                     onPressed: () {
//                       // if (widget.controller.isForeground() == true) {
//                       Navigator.pop(context);
//                       // } else if (widget.controller.isForeground() == false) {
//
//                       //   Navigator.pushReplacement(
//                       //     MyApp.navigatorKey.currentContext!,
//                       //     MaterialPageRoute(
//                       //         builder: (context) => const HomePage()),
//                       //   );
//                       // } else {}
//
//                       widget.controller.disconnect(true);
//                     },
//                     buttonName: "end"),
//               ),
//               const SizedBox(height: 10),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 24.0),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     InkWell(
//                       onTap: () {
//                         widget.controller.toggleVideoCam();
//                         widget
//                             .controller.client!.sessionController.value.engine!
//                             .enableLocalVideo(
//                                 widget.controller.enableVideo != null &&
//                                     widget.controller.enableVideo!);
//                         setState(() {});
//                       },
//                       child: Container(
//                         height: 43,
//                         width: 137,
//                         decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(25),
//                             color: AppColors.primary1[100]!.withOpacity(0.3)),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Icon(
//                               widget.controller.enableVideo!
//                                   ? Icons.videocam
//                                   : Icons.videocam_off,
//                               color: AppColors.primaryWhite,
//                             ),
//                             const SizedBox(width: 5),
//                             Text(
//                               widget.controller.enableVideo!
//                                   ? 'Camera on'
//                                   : "Camera off",
//                               style: AppTextStyles.body4
//                                   .copyWith(color: AppColors.primaryWhite),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     InkWell(
//                       onTap: () {
//                         widget.controller.speakerBeforeCall =
//                             !widget.controller.speakerBeforeCall;
//                         widget.controller.client!.engine.setEnableSpeakerphone(
//                             widget.controller.speakerBeforeCall);
//                         setState(() {});
//                       },
//                       child: Container(
//                         height: 43,
//                         width: 137,
//                         decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(25),
//                             color: AppColors.primary1[100]!.withOpacity(0.3)),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Icon(
//                               widget.controller.speakerBeforeCall
//                                   ? Icons.volume_up
//                                   : Icons.volume_off,
//                               color: AppColors.primaryWhite,
//                             ),
//                             const SizedBox(width: 5),
//                             Text(
//                               tr(context).speaker,
//                               style: AppTextStyles.body4
//                                   .copyWith(color: AppColors.primaryWhite),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
