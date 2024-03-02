import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:messaging_core/app/page_routing/custom_transition.dart';
import 'package:messaging_core/app/theme/constants.dart';
import 'package:messaging_core/features/chat/presentation/manager/call_controller.dart';
import 'package:messaging_core/features/chat/presentation/pages/call/before_call_widget.dart';
import 'package:messaging_core/features/chat/presentation/pages/call/in_call_widget.dart';
import 'package:messaging_core/features/chat/presentation/pages/call/rejected-call-widget.dart';
import 'package:messaging_core/features/chat/presentation/pages/call/ringing-call-widget.dart';
import 'package:messaging_core/features/chat/presentation/pages/call/waiting-call-widget.dart';
import 'package:messaging_core/locator.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class CallPage extends StatefulWidget {
  const CallPage({super.key});

  @override
  CallPageState createState() => CallPageState();
}

class CallPageState extends State<CallPage> {
  CallPageState();
  final player = AudioPlayer();
  double speakerAudio = 2.5;
  double nonSpeakerAudio = 0.3;

  final CallController controller = locator<CallController>();

  @override
  void initState() {
    WakelockPlus.enable();

    super.initState();
  }

  @override
  void dispose() {
    WakelockPlus.disable();
    super.dispose();
    player.dispose();
  }

  void stopCallRinging() {
    player.stop();
    player.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MyWillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: GetBuilder<CallController>(builder: (_) {
          switch (controller.status) {
            case CallStatus.IN_CALL:
              stopCallRinging();
              return InCallPage(
                controller: controller,
              );
            case CallStatus.RINGING:
              player.setAsset(Assets.ringingPhoneAudio);
              player.play();
              return RingingCallPage(
                controller: controller,
              );
            case CallStatus.WAITING:
              // handleAudioSound(controller);
              player.setAsset(Assets.callingPhoneAudio);
              player.play();
              return WaitingCallPage(
                controller: controller,
                stopCallCallback: stopCallRinging,
              );
            case CallStatus.REJECTED:
              return RejectedCallPage(
                controller: controller,
              );
            case CallStatus.NO_CALL:
              return const BeforeCallPage();
            case CallStatus.WAITING_TOKEN:
              return const BeforeCallPage();
          }
        }),
      ),
    );
  }

  void handleAudioSound(CallController callProvider) {
    // if (callProvider.speakerBeforeCall) {
    //   player.setVolume(speakerAudio);
    // } else {
    //   player.setVolume(nonSpeakerAudio);
    // }
  }
}
