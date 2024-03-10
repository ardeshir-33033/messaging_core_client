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
import 'package:messaging_core/features/chat/presentation/manager/emoji_controller.dart';
import 'package:messaging_core/features/chat/presentation/manager/record_voice_controller.dart';
import 'package:messaging_core/features/chat/presentation/widgets/attach_file_bottom_sheet_widget.dart';
import 'package:messaging_core/features/chat/presentation/widgets/conversaion_voice_recording_option_widget.dart';
import 'package:messaging_core/features/chat/presentation/widgets/send_button_widget.dart';
import 'package:messaging_core/features/chat/presentation/widgets/send_message_widgets/edit_message_widget.dart';
import 'package:messaging_core/features/chat/presentation/widgets/send_message_widgets/reply_send_message_widget.dart';
import 'package:messaging_core/locator.dart';

class SendMessageWidget extends StatefulWidget {
  const SendMessageWidget(
      {super.key,
      required this.textController,
      required this.chat,
      required this.onUpdateScroll,
      required this.scrollController});

  final TextEditingController textController;
  final ChatParentClass chat;
  final VoidCallback onUpdateScroll;
  final ScrollController scrollController;

  @override
  State<SendMessageWidget> createState() => _SendMessageWidgetState();
}

class _SendMessageWidgetState extends State<SendMessageWidget> {
  RecordVoiceController voiceController = Get.find<RecordVoiceController>();
  final ChatController controller = locator<ChatController>();
  final EmojiController emojiController = Get.find<EmojiController>();
  final FocusNode focusNode = FocusNode();

  @override
  void initState() {
    focusNode.addListener(() {
      if (!focusNode.hasFocus) {
        controller.sendUserStoppedTyping();
      } else {
        emojiController.stopShowingEmoji();
        controller.sendUserTyping();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatController>(
        id: "sendMessage",
        builder: (_) {
          if (controller.editingContent != null) {
            widget.textController.text = controller.editingContent!.messageText;
          }
          return Column(
            children: [
              if (controller.repliedContent != null) ReplySendMessageWidget(),
              if (controller.editingContent != null)
                EditMessageWidget(
                  onRemoveEdit: () {
                    widget.textController.text = "";
                  },
                ),
              const Divider(
                color: Color(0xFFD6D6D6),
                thickness: 2,
                height: 0,
              ),
              const SizedBox(height: 5),
              Row(
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
                              crossFadeState: voiceController.recordingState ==
                                      RecordStateEnum.stop
                                  ? CrossFadeState.showFirst
                                  : CrossFadeState.showSecond,
                              secondChild:
                                  ConversationVoiceRecordingOptionWidget(
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
                                  voiceController.stopRecording(widget.chat);
                                  widget.onUpdateScroll();
                                },
                                recordState: voiceController.recordingState,
                              ),
                              firstChild: Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      // setState(() {
                                      emojiController.changeEmojiState();
                                      if (!emojiController.emojiShowing) {
                                        WidgetsBinding.instance
                                            .addPostFrameCallback((_) {
                                          focusNode.requestFocus();
                                        });
                                      } else {
                                        focusNode.unfocus();
                                      }
                                      // });
                                    },
                                    child: const IconWidget(
                                      icon: Assets.addSticker,
                                      size: 30,
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  if (controller.editingContent == null)
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
                                          scrollController:
                                              widget.scrollController,
                                          onChanged: (val) {
                                            setState(() {});
                                          },
                                          focusNode: focusNode,
                                          maxLines: 7,
                                          minLines: 1,
                                          textAlignVertical:
                                              TextAlignVertical.center,
                                          controller: widget.textController,
                                          textDirection: directionOf(
                                              widget.textController.text),
                                          decoration: InputDecoration(
                                              filled: true,
                                              fillColor: Colors.transparent,
                                              hintText: tr(context).hintMessage,
                                              hintStyle: AppTextStyles.overline1
                                                  .copyWith(
                                                      color: const Color(
                                                          0xFFBEBEBE)),
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
                              voiceController.stopRecording(widget.chat);
                              widget.onUpdateScroll();
                            },
                            onSendTextMessage: () {
                              controller.sendTextMessage(
                                  widget.textController.text,
                                  widget.chat.id!,
                                  null,
                                  null,
                                  null);
                              widget.textController.text = "";
                              widget.onUpdateScroll();
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
              ),
            ],
          );
        });
  }

  showAttachFileBottomSheet() {
    CustomBottomSheet.showSimpleSheet(
        context,
        (context) => AttachFileBottomSheet(
              chat: widget.chat,
            ));
  }
}
