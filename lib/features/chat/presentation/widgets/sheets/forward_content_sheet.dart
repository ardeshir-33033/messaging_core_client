import 'dart:io';

import 'package:flutter/material.dart';
import 'package:messaging_core/app/theme/app_colors.dart';
import 'package:messaging_core/app/theme/app_text_styles.dart';
import 'package:messaging_core/app/widgets/text_widget.dart';
import 'package:messaging_core/core/services/media_handler/file_model.dart';
import 'package:messaging_core/core/utils/extensions.dart';
import 'package:messaging_core/features/chat/domain/entities/chats_parent_model.dart';
import 'package:messaging_core/features/chat/domain/entities/content_model.dart';
import 'package:messaging_core/features/chat/presentation/manager/chat_controller.dart';
import 'package:messaging_core/features/chat/presentation/pages/chat_page.dart';
import 'package:messaging_core/features/chat/presentation/widgets/channel_list_item.dart';
import 'package:messaging_core/locator.dart';
import 'package:messaging_core/main.dart';

class ForwardContentSheet extends StatefulWidget {
  final ContentModel contentModel;

  const ForwardContentSheet({
    Key? key,
    required this.contentModel,
  }) : super(key: key);

  @override
  State<ForwardContentSheet> createState() => _ForwardContentSheetState();
}

class _ForwardContentSheetState extends State<ForwardContentSheet> {
  final ChatController controller = locator<ChatController>();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: TextWidget(
                tr(context).forward,
                style: AppTextStyles.subtitle4.copyWith(
                  color: const Color(0xff272B38),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: TextWidget(
                  tr(context).cancel,
                  style: AppTextStyles.button2.copyWith(
                    color: AppColors.primary1,
                  ),
                ),
              ),
            )
          ],
        ),
        const SizedBox(height: 24),
        TextWidget(
          tr(context).yourChat,
          style: AppTextStyles.overline2.copyWith(
            color: AppColors.primary3[600],
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        SizedBox(
          height: context.heightPercentage(40),
          child: ListView.separated(
            itemCount: controller.chats.length,
            shrinkWrap: true,
            separatorBuilder: (context, index) {
              return const SizedBox(
                height: 5,
              );
            },
            itemBuilder: (context, index) {
              return ChannelListItemWidget(
                chat: controller.chats[index],
                hasRadioButton: false,
                onTap: () {
                  onSelectChannel(controller.chats[index]);
                },
              );
            },
          ),
        ),
        isLoading
            ? const Center(
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(),
                    )
                  ],
                ),
              )
            : const SizedBox(
                height: 30,
              )
      ],
    );
  }

  Future<void> onSelectChannel(ChatParentClass chat) async {
    final navigator = Navigator.of(context);
    isLoading = true;
    setState(() {});
    controller.setCurrentChat(chat);
    controller.joinRoom();
    controller.sendTextMessage(
        widget.contentModel.messageText,
        chat.id!,
        widget.contentModel.contentType,
        widget.contentModel.filePath != null
            ? FileModel(
                formData: File(widget.contentModel.filePath!).readAsBytesSync(),
                fileName: widget.contentModel.messageText)
            : null);
    await Future.delayed(const Duration(milliseconds: 600));
    isLoading = false;
    navigator.pop();
    MyApp.navigatorKey.currentState!.pushReplacement(
      MaterialPageRoute(
        builder: (context) => ChatPage(chat: chat),
      ),
    );
  }
}
