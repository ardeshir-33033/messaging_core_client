import 'package:flutter/material.dart';
import 'package:messaging_core/app/component/base_bottom_sheets.dart';
import 'package:messaging_core/app/theme/app_text_styles.dart';
import 'package:messaging_core/app/theme/constants.dart';
import 'package:messaging_core/app/widgets/icon_widget.dart';
import 'package:messaging_core/core/services/media_handler/voice_handler.dart';
import 'package:messaging_core/core/utils/extensions.dart';
import 'package:messaging_core/core/utils/text_utils.dart';
import 'package:messaging_core/features/chat/domain/entities/chats_parent_model.dart';
import 'package:messaging_core/features/chat/presentation/widgets/attach_file_bottom_sheet_widget.dart';
import 'package:messaging_core/features/chat/presentation/widgets/conversaion_voice_recording_option_widget.dart';

class SendMessageWidget extends StatefulWidget {
  const SendMessageWidget(
      {super.key, required this.textController, required this.chat});

  final TextEditingController textController;
  final ChatParentClass chat;

  @override
  State<SendMessageWidget> createState() => _SendMessageWidgetState();
}

class _SendMessageWidgetState extends State<SendMessageWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const IconWidget(
          icon: Assets.addSticker,
          size: 30,
        ),
        const SizedBox(width: 5),
        InkWell(
          onTap: () {
            showAttachFileBottomSheet();
          },
          child: const IconWidget(
            icon: Assets.attach,
            size: 30,
          ),
        ),
        ValueListenableBuilder(
            valueListenable: VoiceHandler().recordingState,
            builder: (context, recordingState, child) {
              return Row(
                children: [
                  Expanded(
                    child: AnimatedCrossFade(
                      duration: const Duration(milliseconds: 200),
                      crossFadeState: recordingState == RecordStateEnum.stop
                          ? CrossFadeState.showFirst
                          : CrossFadeState.showSecond,
                      secondChild: ConversationVoiceRecordingOptionWidget(
                        onPauseRecording: () {
                          VoiceHandler().pauseRecording();
                        },
                        onResumeRecording: () {
                          VoiceHandler().resumeRecording();
                        },
                        onDeleteRecording: () {
                          VoiceHandler().cancelRecording();
                        },
                        onSendVoiceMessage: () {
                          VoiceHandler()
                              .stopRecording(widget.chat.id.toString());
                        },
                        recordState: recordingState,
                      ),
                      firstChild: Row(
                        children: [
                          Expanded(
                              child: TextField(
                                  key: const Key("messageField"),
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                  maxLines: 7,
                                  minLines: 1,
                                  textAlignVertical: TextAlignVertical.center,
                                  controller: widget.textController,
                                  textDirection:
                                      directionOf(widget.textController.text),
                                  decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.transparent,
                                      hintText: tr(context).hintMessage,
                                      hintStyle: AppTextStyles.overline1
                                          .copyWith(
                                              color: const Color(0xFFBEBEBE)),
                                      border: InputBorder.none))),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }),
        const IconWidget(
          icon: Assets.microphone,
          size: 30,
        ),
      ],
    );
  }

  showAttachFileBottomSheet() {
    CustomBottomSheet.showSimpleSheet(
        context,
        (context) => AttachFileBottomSheet(
              chat: widget.chat,
            ));
  }
}
