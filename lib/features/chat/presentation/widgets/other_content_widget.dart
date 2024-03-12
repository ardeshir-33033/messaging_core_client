import 'package:flutter/material.dart';
import 'package:messaging_core/core/enums/content_type_enum.dart';
import 'package:messaging_core/features/chat/domain/entities/contact_payload_model.dart';
import 'package:messaging_core/features/chat/domain/entities/content_payload_model.dart';
import 'package:messaging_core/features/chat/domain/entities/location_payload_model.dart';
import 'package:messaging_core/features/chat/presentation/widgets/chat_page_widgets/contact_content_widget.dart';
import 'package:messaging_core/features/chat/presentation/widgets/chat_page_widgets/location_content_widget.dart';

class OtherContentWidget extends StatelessWidget {
  const OtherContentWidget(
      {super.key,
      required this.otherContentType,
      required this.contentPayloadModel});
  final ContentTypeEnum otherContentType;
  final ContentPayloadModel contentPayloadModel;
  @override
  Widget build(BuildContext context) {
    return Builder(builder: (_) {
      switch (contentPayloadModel.getContentType()) {
        case ContentTypeEnum.contact:
          return ContactContentWidget(
              contactPayloadModel: contentPayloadModel as ContactPayloadModel);
        case ContentTypeEnum.location:
          return LocationContentWidget(
              locationPayloadModel:
                  contentPayloadModel as LocationPayloadModel);
        default:
          return LocationContentWidget(
              locationPayloadModel:
              contentPayloadModel as LocationPayloadModel);
          // return Placeholder();
      }
    });
  }
}
