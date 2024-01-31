import 'package:messaging_core/core/enums/content_type_enum.dart';
import 'package:messaging_core/features/chat/domain/entities/text_content_payload_model.dart';

abstract class ContentPayloadModel {
  ContentTypeEnum getContentType();

  Map<String, dynamic> toJson();

  String shortDisplayName();

  static create(ContentTypeEnum contentType, Map<String, dynamic> json) {
    switch (contentType) {
      case ContentTypeEnum.text:
        return TextContentPayloadModel.fromJson(json);

      default:
        return TextContentPayloadModel.fromJson(json);
    }
  }
}
