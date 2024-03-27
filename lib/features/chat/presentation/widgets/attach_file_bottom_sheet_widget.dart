import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:messaging_core/app/component/base_bottom_sheets.dart';
import 'package:messaging_core/app/theme/app_text_styles.dart';
import 'package:messaging_core/app/theme/constants.dart';
import 'package:messaging_core/app/widgets/icon_widget.dart';
import 'package:messaging_core/core/enums/content_type_enum.dart';
import 'package:messaging_core/core/services/media_handler/file_handler.dart';
import 'package:messaging_core/core/services/media_handler/file_model.dart';
import 'package:messaging_core/core/services/media_handler/image_handler.dart';
import 'package:messaging_core/core/services/navigation/navigation_controller.dart';
import 'package:messaging_core/core/utils/extensions.dart';
import 'package:messaging_core/features/chat/domain/entities/chats_parent_model.dart';
import 'package:messaging_core/features/chat/presentation/manager/chat_controller.dart';
import 'package:messaging_core/features/chat/presentation/pages/edit_image_page.dart';
import 'package:messaging_core/features/chat/presentation/pages/map_page.dart';
import 'package:messaging_core/features/chat/presentation/widgets/contacts_bottom_sheet.dart';
import 'package:messaging_core/locator.dart';
import 'package:url_launcher/url_launcher.dart';

class AttachFileBottomSheet extends StatelessWidget {
  AttachFileBottomSheet({super.key, required this.chat});

  final ChatParentClass chat;
  final Navigation navigation = locator<Navigation>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GridView.count(
          crossAxisCount: 3,
          shrinkWrap: true,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          children: [
            AttachDataItem(
                title: tr(context).gallery,
                onPressed: () async {
                  final navigator = Navigator.of(context);
                  navigator.pop();

                  FileModel? file = await ImageHandler()
                      .selectImageFile(source: ImageSource.gallery);
                  if (file != null) {
                    final ChatController controller = locator<ChatController>();
                    controller.sendTextMessage(file.fileName ?? "Image",
                        chat.id!, ContentTypeEnum.image, file, null);
                  }
                },
                icon: Assets.gallery),
            AttachDataItem(
                title: tr(context).file,
                onPressed: () {
                  final navigator = Navigator.of(context);
                  navigator.pop();
                  FileHandler().selectAndSendFile(chat);
                },
                icon: Assets.file),
            AttachDataItem(
                title: tr(context).camera,
                onPressed: () async {
                  final navigator = Navigator.of(context);
                  navigator.pop();
                  FileModel? file = await ImageHandler()
                      .selectImageFile(source: ImageSource.camera);
                  if (file != null) {
                    // navigator.pop();
                    final ChatController controller = locator<ChatController>();
                    controller.sendTextMessage(file.fileName ?? "Image",
                        chat.id!, ContentTypeEnum.image, file, null);
                  }
                },
                icon: Assets.camera),
            AttachDataItem(
                title: tr(context).location,
                onPressed: () async {
                  final navigator = Navigator.of(context);
                  navigator.pop();
                  navigation.push(const MapPage());
                },
                icon: Assets.location),
            AttachDataItem(
                title: tr(context).music,
                onPressed: () {
                  final navigator = Navigator.of(context);
                  navigator.pop();
                  FileHandler().selectMusicAndSendFile(chat);
                },
                icon: Assets.music),
            AttachDataItem(
                title: tr(context).draw, onPressed: () {}, icon: Assets.draw),
            AttachDataItem(
                title: tr(context).contact,
                onPressed: () {
                  final navigator = Navigator.of(context);
                  navigator.pop();
                  CustomBottomSheet.showSimpleSheet(
                    context,
                    (context) => ContactsBottomSheet(
                      chatId: chat.id!,
                    ),
                  );
                },
                icon: Assets.contact),
            AttachDataItem(
                title: tr(context).document,
                onPressed: () {
                  final navigator = Navigator.of(context);
                  navigator.pop();
                  FileHandler().selectDocumentAndSendFile(chat);
                },
                icon: Assets.document),
            AttachDataItem(
                title: tr(context).poll,
                onPressed: () {
                  final navigator = Navigator.of(context);
                  navigator.pop();
                },
                icon: Assets.poll),
          ],
        ),
        const SizedBox(height: 15),
        InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            width: double.infinity,
            padding: 10.vertical,
            decoration: const BoxDecoration(
              color: Color(0xFFEFEFEF),
            ),
            child: Center(child: Text(tr(context).cancel)),
          ),
        )
      ],
    );
  }

  Future<void> onSendImage(ImageSource imageSource, context) async {
    // dismissOptions();

    return ImageHandler()
        .selectImageFile(source: imageSource, allowCrop: false)
        .then((file) {
      if (file == null) return;

      navigation.push(
        EditImagePage(
          fileModel: file,
          chat: chat,
        ),
      );
    });
  }
}

class AttachDataItem extends StatelessWidget {
  const AttachDataItem(
      {super.key,
      required this.title,
      required this.onPressed,
      required this.icon});

  final String title;
  final String icon;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFEFEFEF),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconWidget(
              icon: icon,
              size: 32,
            ),
            const SizedBox(height: 5),
            Text(
              title,
              style: AppTextStyles.overline1,
            ),
          ],
        ),
      ),
    );
  }
}
