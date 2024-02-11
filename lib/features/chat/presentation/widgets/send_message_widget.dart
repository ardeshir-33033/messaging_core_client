import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:messaging_core/app/component/base_bottom_sheets.dart';
import 'package:messaging_core/app/theme/app_text_styles.dart';
import 'package:messaging_core/app/theme/constants.dart';
import 'package:messaging_core/app/widgets/icon_widget.dart';
import 'package:messaging_core/core/utils/extensions.dart';
import 'package:messaging_core/core/utils/text_utils.dart';
import 'package:messaging_core/features/chat/domain/entities/chats_parent_model.dart';
import 'package:messaging_core/features/chat/presentation/manager/chat_controller.dart';
import 'package:messaging_core/features/chat/presentation/manager/record_voice_controller.dart';
import 'package:messaging_core/features/chat/presentation/widgets/attach_file_bottom_sheet_widget.dart';
import 'package:messaging_core/features/chat/presentation/widgets/conversaion_voice_recording_option_widget.dart';
import 'package:messaging_core/features/chat/presentation/widgets/send_button_widget.dart';
import 'package:messaging_core/locator.dart';

class SendMessageWidget extends StatefulWidget {
  const SendMessageWidget(
      {super.key, required this.textController, required this.chat});

  final TextEditingController textController;
  final ChatParentClass chat;

  @override
  State<SendMessageWidget> createState() => _SendMessageWidgetState();
}

class _SendMessageWidgetState extends State<SendMessageWidget> {
  RecordVoiceController voiceController = Get.find<RecordVoiceController>();
  final ChatController controller = locator<ChatController>();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: GetBuilder<RecordVoiceController>(
              // valueListenable: voiceController.recordingState,
              builder: (_) {
            return Row(
              children: [
                Expanded(
                  child: AnimatedCrossFade(
                    duration: const Duration(milliseconds: 200),
                    crossFadeState:
                        voiceController.recordingState == RecordStateEnum.stop
                            ? CrossFadeState.showFirst
                            : CrossFadeState.showSecond,
                    secondChild: ConversationVoiceRecordingOptionWidget(
                      onPauseRecording: () {
                        voiceController.pauseRecording();
                      },
                      onResumeRecording: () {
                        voiceController.resumeRecording();
                      },
                      onDeleteRecording: () {
                        voiceController.cancelRecording();
                      },
                      onSendVoiceMessage: () {
                        voiceController
                            .stopRecording(widget.chat.id.toString());
                      },
                      recordState: voiceController.recordingState,
                    ),
                    firstChild: Row(
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
                        Expanded(
                            child: TextField(
                                key: const Key("messageField"),
                                textCapitalization:
                                    TextCapitalization.sentences,
                                onChanged: (val) {
                                  setState(() {});
                                },
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
                                    hintStyle: AppTextStyles.overline1.copyWith(
                                        color: const Color(0xFFBEBEBE)),
                                    border: InputBorder.none))),
                      ],
                    ),
                  ),
                ),
                SendButtonWidget(
                  recordState: voiceController.recordingState,
                  onPauseRecording: () {
                    voiceController.pauseRecording();
                  },
                  onCancelRecording: () {
                    voiceController.cancelRecording();
                  },
                  onLockRecord: () {
                    voiceController.lockRecord();
                  },
                  onSendVoiceMessage: () {
                    voiceController.stopRecording(widget.chat.id.toString());
                  },
                  onSendTextMessage: () {
                    controller.sendTextMessage(
                        widget.chat.getReceiverType(),
                        widget.textController.text,
                        widget.chat.id!,
                        widget.chat.groupUsers);
                    widget.textController.text = "";

                    // widget.onSendMessage.call();
                  },
                  onRecordVoice: () {
                    voiceController.recordAudio();
                  },
                  isMessageEmpty: widget.textController.text.isEmpty,
                  voiceMessageEnabled: true,
                ),
              ],
            );
          }),
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
