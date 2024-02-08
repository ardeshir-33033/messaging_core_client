import 'package:flutter/material.dart';
import 'package:messaging_core/app/theme/app_text_styles.dart';
import 'package:messaging_core/core/services/media_handler/voice_handler.dart';
import 'package:messaging_core/core/utils/text_utils.dart';
import 'package:messaging_core/features/chat/presentation/widgets/send_button_widget.dart';

class EditImageSendMessage extends StatefulWidget {
  final TextEditingController messageController;
  final String chatId;
  final VoidCallback onSendMessage;
  final Color textColor;
  final Color borderColor;
  final Color backgroundColor;
  final String hintText;
  final Widget? leadingWidget;
  final bool voiceMessageEnabled;
  final Widget? inputSuffixWidget;

  const EditImageSendMessage({
    Key? key,
    required this.chatId,
    required this.messageController,
    required this.onSendMessage,
    required this.hintText,
    required this.textColor,
    required this.borderColor,
    required this.backgroundColor,
    this.inputSuffixWidget,
    this.voiceMessageEnabled = true,
    this.leadingWidget,
  }) : super(key: key);

  @override
  State<EditImageSendMessage> createState() => _EditImageSendMessageState();
}

class _EditImageSendMessageState extends State<EditImageSendMessage> {
  TextEditingController textEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 10, bottom: 20),
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 16,
              offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ValueListenableBuilder(
            valueListenable: VoiceHandler().recordingState,
            builder: (context, recordingState, child) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: [
                  Expanded(
                    child: AnimatedCrossFade(
                      duration: const Duration(milliseconds: 200),
                      crossFadeState: recordingState == RecordStateEnum.stop
                          ? CrossFadeState.showFirst
                          : CrossFadeState.showSecond,
                      secondChild: Container(),
                      // ConversationVoiceRecordingOptionWidget(
                      //   onPauseRecording: () {
                      //     VoiceHandler().pauseRecording();
                      //   },
                      //   onResumeRecording: () {
                      //     VoiceHandler().resumeRecording();
                      //   },
                      //   onDeleteRecording: () {
                      //     VoiceHandler().cancelRecording();
                      //   },
                      //   onSendVoiceMessage: () {
                      //     VoiceHandler().stopRecording(widget.channelId);
                      //   },
                      //   recordState: recordingState,
                      // ),
                      firstChild: Row(
                        children: <Widget>[
                          if (widget.leadingWidget != null)
                            widget.leadingWidget!,
                          Expanded(
                            child: TextField(
                                style: TextStyle(color: widget.textColor),
                                key: const Key("messageField"),
                                textCapitalization:
                                    TextCapitalization.sentences,
                                maxLines: 7,
                                minLines: 1,
                                controller: widget.messageController,
                                textDirection:
                                    directionOf(widget.messageController.text),
                                decoration: InputDecoration(
                                    filled: true,
                                    fillColor: widget.backgroundColor,
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 8, horizontal: 12),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16.0),
                                      borderSide:
                                          BorderSide(color: widget.borderColor),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16.0),
                                      borderSide:
                                          BorderSide(color: widget.borderColor),
                                    ),
                                    suffixIcon: widget.inputSuffixWidget,
                                    hintText: widget.hintText,
                                    hintStyle: AppTextStyles.overline2
                                        .copyWith(color: widget.textColor),
                                    border: InputBorder.none)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SendButtonWidget(
                    recordState: recordingState,
                    onPauseRecording: () {
                      // VoiceHandler().pauseRecording();
                    },
                    onCancelRecording: () {
                      // VoiceHandler().cancelRecording();
                    },
                    onLockRecord: () {
                      // VoiceHandler().lockRecord();
                    },
                    onSendVoiceMessage: () {
                      // VoiceHandler().stopRecording(widget.channelId);
                    },
                    onSendTextMessage: () {
                      widget.onSendMessage.call();
                    },
                    onRecordVoice: () {
                      // VoiceHandler().recordAudio();
                    },
                    isMessageEmpty: widget.messageController.text.isEmpty,
                    voiceMessageEnabled: widget.voiceMessageEnabled,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // String getSenderName(String senderId) {
  // return currentChannelProvider.members[senderId]?.profile.displayName ??
  //     senderId.toHex().midEllipsis(head: 4, tail: 4);
  // }

  @override
  void dispose() {
    // timer?.cancel();
    super.dispose();
  }
}
