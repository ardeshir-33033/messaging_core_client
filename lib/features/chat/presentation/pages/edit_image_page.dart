import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:messaging_core/app/page_routing/custom_transition.dart';
import 'package:messaging_core/app/theme/app_text_styles.dart';
import 'package:messaging_core/app/widgets/icon_widget.dart';
import 'package:messaging_core/app/widgets/text_widget.dart';
import 'package:messaging_core/core/services/media_handler/file_model.dart';
import 'package:messaging_core/core/services/media_handler/image_handler.dart';
import 'package:messaging_core/core/utils/extensions.dart';
import 'package:messaging_core/features/chat/domain/entities/chats_parent_model.dart';
import 'package:messaging_core/features/chat/presentation/widgets/edit_image_send_message.dart';

class EditImagePage extends StatefulWidget {
  final FileModel fileModel;
  final ChatParentClass chat;

  const EditImagePage({
    super.key,
    required this.chat,
    required this.fileModel,
  });

  @override
  EditImagePageState createState() => EditImagePageState();
}

GlobalKey firstUnreadKey = GlobalKey();

class EditImagePageState extends State<EditImagePage>
    with SingleTickerProviderStateMixin {
  late ChatParentClass channel;
  GlobalKey key = GlobalKey();

  final TextEditingController _sendTextController = TextEditingController();
  late AnimationController _replyToAnimationController;
  late FileModel fileModel;

  @override
  void initState() {
    super.initState();
    fileModel = widget.fileModel;
    ImageHandler();
    // _sendTextController.text = widget.chat.draftMessage ?? "";
    channel = widget.chat;
    _initAnimations();
  }

  @override
  Widget build(BuildContext context) {
    return MyWillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                GestureDetector(
                    onTap: () {
                      print(fileModel);
                    },
                    child: Image.file(File(fileModel.filePath ?? ""))),
                Align(
                  alignment: Alignment.topCenter,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 100),
                    height: 60,
                    color: Colors.black.withOpacity(0.08),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(
                          width: 16,
                        ),
                        IconWidget(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          size: 18,
                          padding: 8,
                          boxFit: BoxFit.scaleDown,
                          boxShape: BoxShape.circle,
                          iconColor: Colors.white,
                          icon: Icons.close,
                          backgroundColor: Colors.black.withOpacity(0.15),
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        IconWidget(
                          onPressed: () async {
                            print("First name: ${fileModel.fileName}");
                            FileModel fileModel2 = await ImageHandler()
                                .cropImage(fileModel, FilePosition.message);
                            print(fileModel.fileName == fileModel2.fileName);
                            print("Second name: ${fileModel2.fileName}");
                            fileModel = fileModel2;

                            setState(() {});
                          },
                          size: 18,
                          padding: 8,
                          boxFit: BoxFit.scaleDown,
                          boxShape: BoxShape.circle,
                          iconColor: Colors.white,
                          icon: Icons.crop,
                          backgroundColor: Colors.black.withOpacity(0.15),
                        ),
                        const Spacer(),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      EditImageSendMessage(
                        chatId: channel.id.toString(),
                        textColor: Colors.white,
                        borderColor: Colors.white,
                        backgroundColor: Colors.black.withOpacity(0.4),
                        hintText: tr(context).hintMessage,
                        messageController: _sendTextController,
                        onSendMessage: () {
                          onSendMessage();
                        },
                        voiceMessageEnabled: false,
                      ),
                      Container(
                        padding: const EdgeInsets.only(
                          right: 16,
                          left: 16,
                          bottom: 16,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.4),
                        ),
                        child: Row(
                          children: [
                            const IconWidget(
                              icon: Icons.arrow_upward_sharp,
                              iconColor: Colors.white,
                              size: 14,
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            TextWidget(
                              channel.name ?? "",
                              style: AppTextStyles.body4
                                  .copyWith(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _sendTextController.dispose();
    _replyToAnimationController.dispose();
    super.dispose();
  }

  Future<void> onSendMessage() async {
    String? caption;
    if (_sendTextController.text.trim().isNotEmpty) {
      caption = _sendTextController.text.trim();
    }

    // ImageHandler().sendMedia(widget.chat.id, fileModel, caption: caption);

    _sendTextController.text = '';
    // getIt.call<CurrentChannelProvider>().repliedContent = null;

    Navigator.pop(context);
  }

  void _initAnimations() {
    _replyToAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      reverseDuration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _replyToAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {});
      }
    });
  }
}
