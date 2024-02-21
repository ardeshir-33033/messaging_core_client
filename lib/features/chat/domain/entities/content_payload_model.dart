import 'dart:convert';

import 'package:messaging_core/core/enums/content_type_enum.dart';
import 'package:messaging_core/core/enums/other_content_type_enum.dart';
import 'package:messaging_core/features/chat/domain/entities/contact_payload_model.dart';
import 'package:messaging_core/features/chat/domain/entities/text_content_payload_model.dart';

abstract class ContentPayloadModel {
  ContentTypeEnum getContentType();

  Map<String, dynamic> toJson();

  String shortDisplayName();

  static create(ContentTypeEnum contentType, String json) {
    switch (contentType) {
      case ContentTypeEnum.text:
        return TextContentPayloadModel.fromJson(json);
      case ContentTypeEnum.other:
        final content = jsonDecode(json);
        switch (OtherContentTypeEnum.fromString(content["content_Type"])) {
          case OtherContentTypeEnum.contact:
            if (content["data"] == null) {
              return ContactPayloadModel(
                  contentType:
                      ContentTypeEnum.fromString(content["content_Type"]),
                  contactName: content["contact_name"],
                  contactNumber: content["contact_number"]);
            }
            return ContactPayloadModel.fromJson(content["data"]);
          case OtherContentTypeEnum.unsupported:
            return ContactPayloadModel.fromJson(content["data"]);
        }

        return TextContentPayloadModel.fromJson(json);
      default:
        return TextContentPayloadModel.fromJson(json);
    }
  }
}
