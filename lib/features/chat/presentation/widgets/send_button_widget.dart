import 'package:flutter/material.dart';
import 'package:messaging_core/app/theme/app_colors.dart';
import 'package:messaging_core/app/theme/constants.dart';
import 'package:messaging_core/app/widgets/icon_widget.dart';
import 'package:messaging_core/core/services/media_handler/voice_handler.dart';
import 'package:messaging_core/features/chat/presentation/manager/record_voice_controller.dart';

class SendButtonWidget extends StatelessWidget {
  final RecordStateEnum recordState;
  final VoidCallback onSendVoiceMessage;
  final VoidCallback onSendTextMessage;
  final VoidCallback onRecordVoice;
  final VoidCallback onPauseRecording;
  final VoidCallback onCancelRecording;
  final VoidCallback onLockRecord;
  final bool isMessageEmpty;
  final bool voiceMessageEnabled;

  const SendButtonWidget({
    Key? key,
    required this.recordState,
    required this.onPauseRecording,
    required this.onSendVoiceMessage,
    required this.onSendTextMessage,
    required this.onRecordVoice,
    required this.isMessageEmpty,
    required this.onCancelRecording,
    required this.onLockRecord,
    required this.voiceMessageEnabled,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Offset buttonOffset = Offset.zero;
    if (context.findRenderObject() != null &&
        context.findRenderObject() is RenderBox) {
      Offset? offset =
          (context.findRenderObject() as RenderBox).localToGlobal(Offset.zero);
      if (offset != null) {
        buttonOffset = offset;
      }
    }

    RecordStateEnum recordStateEnum = recordState;
    return Listener(
      onPointerDown: (event) {
        if (recordStateEnum == RecordStateEnum.record ||
            recordStateEnum == RecordStateEnum.lockRecord ||
            recordStateEnum == RecordStateEnum.pause) return;
        if (voiceMessageEnabled && isMessageEmpty) {
          recordStateEnum = RecordStateEnum.record;
          onRecordVoice.call();
        } else {
          onSendTextMessage.call();
        }
      },
      onPointerUp: (event) {
        if (recordStateEnum == RecordStateEnum.stop ||
            recordStateEnum == RecordStateEnum.lockRecord ||
            recordStateEnum == RecordStateEnum.pause) return;
        onSendVoiceMessage.call();
      },
      onPointerMove: (details) {
        if (recordStateEnum == RecordStateEnum.lockRecord ||
            recordStateEnum == RecordStateEnum.pause) return;
        if ((buttonOffset.dx - 70) > details.position.dx &&
            recordStateEnum == RecordStateEnum.record) {
          onCancelRecording.call();
          return;
        }
        if (buttonOffset.dy - 70 > details.position.dy &&
            recordStateEnum == RecordStateEnum.record) {
          recordStateEnum = RecordStateEnum.lockRecord;
          onLockRecord.call();
        }
      },
      child: Builder(builder: (context) {
        if (recordStateEnum == RecordStateEnum.pause ||
            recordStateEnum == RecordStateEnum.lockRecord) {
          return const SizedBox.shrink();
        }
        return recordStateEnum == RecordStateEnum.record
            ? const RecordButtonWidget()
            : SizedBox(
                width: 40,
                child: IconWidget(
                  padding: 8,
                  icon: (voiceMessageEnabled && isMessageEmpty)
                      ? Assets.microphone
                      : Assets.sendMessageIcon,
                  size: 30,
                  key: const Key("sendMessage"),
                ),
              );
      }),
    );
  }
}

class RecordButtonWidget extends StatefulWidget {
  const RecordButtonWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<RecordButtonWidget> createState() => _RecordButtonWidgetState();
}

class _RecordButtonWidgetState extends State<RecordButtonWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation _animation;

  @override
  void initState() {
    super.initState();
    initRecordButtonAnimation();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _animation.removeListener(_animationListener);
    super.dispose();
  }

  void _animationListener() {
    setState(() {});
  }

  void initRecordButtonAnimation() {
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 2000));
    _animationController.repeat(reverse: true);
    _animation = Tween(begin: 2.0, end: 8.0).animate(_animationController)
      ..addListener(_animationListener);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          height: 50,
          width: 50,
          child: Center(
            child: Container(
              width: 40.0 + _animation.value,
              height: 40.0 + _animation.value,
              decoration: const BoxDecoration(
                color: Color(0xff82B3F4),
                shape: BoxShape.circle,
              ),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Container(
                  width: 36.0 + _animation.value,
                  height: 36.0 + _animation.value,
                  decoration: const BoxDecoration(
                    color: Color(0xff5999F1),
                    shape: BoxShape.circle,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: const BoxDecoration(
                        color: AppColors.primary1,
                        shape: BoxShape.circle,
                      ),
                      child: const IconWidget(
                        icon: Assets.microphone,
                        iconColor: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        // const LockRecord(),
      ],
    );
  }
}
