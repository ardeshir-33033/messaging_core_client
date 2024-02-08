import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:messaging_core/app/theme/app_text_styles.dart';
import 'package:messaging_core/app/theme/constants.dart';
import 'package:messaging_core/app/widgets/icon_widget.dart';
import 'package:messaging_core/core/services/media_handler/image_handler.dart';
import 'package:messaging_core/core/utils/extensions.dart';
import 'package:messaging_core/features/chat/domain/entities/chats_parent_model.dart';
import 'package:messaging_core/features/chat/presentation/pages/edit_image_page.dart';

class AttachFileBottomSheet extends StatelessWidget {
  const AttachFileBottomSheet({super.key, required this.chat});

  final ChatParentClass chat;

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
                onPressed: () {},
                icon: Assets.gallery),
            AttachDataItem(
                title: tr(context).file, onPressed: () {}, icon: Assets.file),
            AttachDataItem(
                title: tr(context).camera,
                onPressed: () {},
                icon: Assets.camera),
            AttachDataItem(
                title: tr(context).location,
                onPressed: () {},
                icon: Assets.location),
            AttachDataItem(
                title: tr(context).music, onPressed: () {}, icon: Assets.music),
            AttachDataItem(
                title: tr(context).draw, onPressed: () {}, icon: Assets.draw),
            AttachDataItem(
                title: tr(context).contact,
                onPressed: () {},
                icon: Assets.contact),
            AttachDataItem(
                title: tr(context).document,
                onPressed: () {},
                icon: Assets.document),
            AttachDataItem(
                title: tr(context).poll, onPressed: () {}, icon: Assets.poll),
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
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: const Color(0xFFEFEFEF),
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

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EditImagePage(
            fileModel: file,
            chat: chat,
          ),
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
          borderRadius: BorderRadius.circular(20),
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
