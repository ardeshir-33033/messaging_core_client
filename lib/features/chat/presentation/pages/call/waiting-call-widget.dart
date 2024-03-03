import 'dart:ui';

import 'package:agora_uikit/agora_uikit.dart';
import 'package:expandable_bottom_sheet/expandable_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:messaging_core/app/theme/constants.dart';
import 'package:messaging_core/core/utils/utils.dart';
import 'package:messaging_core/features/chat/presentation/manager/call_controller.dart';

import '../../widgets/agora_widgets/agora_custom_buttons.dart';

class WaitingCallPage extends StatefulWidget {
  const WaitingCallPage({
    super.key,
    required this.controller,
    required this.stopCallCallback,
  });

  final Function() stopCallCallback;
  final CallController controller;

  @override
  State<WaitingCallPage> createState() => _WaitingCallPageState();
}

class _WaitingCallPageState extends State<WaitingCallPage> {
  GlobalKey<ExpandableBottomSheetState> key = GlobalKey();

  @override
  void initState() {
    super.initState();
    postFrameCallback(() {
      Future.delayed(const Duration(milliseconds: 200), () {
        key.currentState!.expand();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ExpandableBottomSheet(
        key: key,
        expandableContent: Container(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E1E).withOpacity(0.5),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: SingleChildScrollView(
                    child: Container(
                        height: 100,
                        margin: const EdgeInsets.symmetric(horizontal: 22),
                        child: GetBuilder<CallController>(builder: (_) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // AgoraCustomButton(
                              //     icon:
                              //     widget.controller.mutedBeforeCall
                              //         ? Icons.mic_off
                              //         : Icons.mic,
                              //     onPressed: () {
                              //       widget.controller.changeBeforeCallMuteValue();
                              //     },
                              //     buttonName: "mute"),
                              // AgoraCustomButton(
                              //     icon: widget.controller.speakerBeforeCall
                              //         ? Icons.volume_up
                              //         : Icons.volume_off,
                              //     onPressed: () {
                              //       widget.controller.changeBeforeCallSpeakerValue();
                              //     },
                              //     buttonName: "Speaker"),
                              AgoraCustomButton(
                                  assetIcon: Assets.closeAgora,
                                  color: const Color(0xFFEB5757),
                                  onPressed: () {
                                    widget.stopCallCallback();
                                    Navigator.pop(context);
                                    widget.controller.disconnect(true);
                                  },
                                  buttonName: "end"),
                            ],
                          );
                        })),
                  ),
                ),
              ],
            ),
          ),
        ),
        persistentHeader: Container(
          height: 50,
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E1E).withOpacity(0.5),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          child: Center(
            child: Container(
              width: 25,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(1000),
              ),
            ),
          ),
        ),
        background: Stack(
          children: [
            // Background
            Positioned(
              top: 0,
              bottom: 0,
              right: 0,
              left: 0,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      colors: [
                        Color(0xFF56C5AD),
                        Color(0xFF4372B4),
                        Color(0xFF21205A)
                      ],
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      stops: [0.15, 0.3, 1]),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                  child: Container(
                    decoration:
                        BoxDecoration(color: Colors.white.withOpacity(0.30)),
                  ),
                ),
              ),
            ),

            // Avatar
            Positioned(
                top: MediaQuery.of(context).size.height / 4,
                right: 0,
                left: 0,
                child: Center(
                  child: Column(
                    children: [
                      SizedBox(
                        width: 80,
                        height: 80,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(1000),
                          child: Image(
                            image:
                                // (widget.controller.profile == null ||
                                //         widget.controller.profile!.avatarUrl ==
                                //             null ||
                                //         widget.controller.profile!.avatarUrl
                                //                 ?.isEmpty ==
                                //             true)
                                //     ?
                                Image.asset('assets/images/default.jpg').image,
                            // : NetworkImage(widget
                            //     .controller.profile!.avatarUrl.last),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          "",
                          // widget.controller.profile == null
                          //     ? (widget.controller.opponentId == null
                          //         ? ''
                          //         : widget.controller.opponentId!
                          //             .midEllipsis())
                          //     : widget.controller.profile!.displayName,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.call,
                            color: Colors.white,
                          ),
                          SizedBox(width: 10),
                          Text(
                            'Calling...',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                )),
            // Call Actions
          ],
        ),
      ),
    );
  }
}
