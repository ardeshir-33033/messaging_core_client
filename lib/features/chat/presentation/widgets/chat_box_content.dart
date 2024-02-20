import 'package:flutter/material.dart';
import 'package:messaging_core/app/theme/app_text_styles.dart';
import 'package:messaging_core/app/widgets/text_widget.dart';
import 'package:messaging_core/core/enums/content_type_enum.dart';
import 'package:messaging_core/core/enums/message_status.dart';
import 'package:messaging_core/core/utils/extensions.dart';
import 'package:messaging_core/features/chat/domain/entities/contact_profile_model.dart';
import 'package:messaging_core/features/chat/domain/entities/content_model.dart';
import 'package:messaging_core/features/chat/domain/entities/text_content_payload_model.dart';
import 'package:messaging_core/features/chat/presentation/widgets/file_content_widget.dart';
import 'package:messaging_core/features/chat/presentation/widgets/image_content_widget.dart';
import 'package:messaging_core/features/chat/presentation/widgets/other_content_widget.dart';
import 'package:messaging_core/features/chat/presentation/widgets/text_content_widget.dart';
import 'package:messaging_core/features/chat/presentation/widgets/video_content_widget.dart';
import 'package:messaging_core/features/chat/presentation/widgets/voice_content_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class ChatBoxContent extends StatelessWidget {
  final ContentModel contentModel;
  final Key keyId;
  final bool isMine;
  final String senderName;
  final ContactProfile? opponentProfile;

  const ChatBoxContent({
    Key? key,
    required this.keyId,
    required this.contentModel,
    required this.isMine,
    required this.senderName,
    this.opponentProfile,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (contentModel.contentType) {
      case ContentTypeEnum.text ||
            ContentTypeEnum.linkableText ||
            ContentTypeEnum.encryptedText:
        return TextContentWidget(
          content: contentModel.messageText,
          keyId: keyId,
        );
      case ContentTypeEnum.image:
        return ImageContentWidget(
          originalUrl: contentModel.filePath!,
          contentModel: contentModel,
          // imageWidth: payload.width,
          // imageHeight: payload.height,
        );
      case ContentTypeEnum.voice:
        // var payload = contentModel.contentPayload as VoiceContentPayloadModel;
        return VoiceContentWidget(
          contentModel: contentModel,
          contentId: contentModel.contentId.toString(),
          isUploading: contentModel.status == MessageStatus.pending,
          // senderName: isMine ? tr(context).you : senderName,
        );

      case ContentTypeEnum.other:
        ContentTypeEnum otherContentType =
            contentModel.contentPayload!.getContentType();

        return OtherContentWidget(
          otherContentType: otherContentType,
          contentPayloadModel: contentModel.contentPayload!,
        );

      // case ContentTypeEnum.transaction:
      //   return TransactionContentWidget(
      //     transactionPayload:
      //         contentModel.contentPayload as TransactionContentPayloadModel,
      //     onTap: () {},
      //   );
      // case ContentTypeEnum.command:
      //   return CommandContentWidget(
      //     commandContentPayloadModel:
      //         contentModel.contentPayload as CommandContentPayloadModel,
      //   );
      case ContentTypeEnum.video:
        return VideoContentWidget(contentModel: contentModel);
      case ContentTypeEnum.file:
        return FileContentWidget(
          isUploading: false,
          contentModel: contentModel,
        );
      case ContentTypeEnum.localDeleted:
        return _localDeletedContentType(context, keyId);
      default:
        return _unsupportedContentType(context, keyId);
    }
  }

  Widget _localDeletedContentType(BuildContext context, Key keyId) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(
          Icons.block,
          size: 16,
          color: Color.fromARGB(255, 78, 86, 96),
        ),
        const SizedBox(
          width: 4,
        ),
        TextContentWidget(
          content: tr(context).localDeletedContentText,
          keyId: keyId,
          textColor: const Color.fromARGB(255, 78, 86, 96),
        ),
      ],
    );
  }

  Widget _unsupportedContentType(BuildContext context, Key keyId) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextContentWidget(
          content: tr(context).unsupportedContentText,
          keyId: keyId,
        ),
        const SizedBox(
          height: 4,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            InkWell(
              onTap: () {
                launchUrl(
                  Uri.parse("dynamicLink"),
                  mode: LaunchMode.externalApplication,
                );
              },
              child: TextWidget(
                tr(context).download,
                style: AppTextStyles.link.copyWith(
                  color: const Color(0xff2F80ED),
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
