import '../../../../core/enums/content_type_enum.dart';
import 'content_payload_model.dart';

class TextContentPayloadModel extends ContentPayloadModel {
  String text;

  TextContentPayloadModel(this.text);

  TextContentPayloadModel.fromJson(String json)
      : text = json ?? '';

  @override
  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'contentType': ContentTypeEnum.text.name,
    };
  }

  @override
  ContentTypeEnum getContentType() {
    return ContentTypeEnum.text;
  }

  @override
  String shortDisplayName() {
    return text;
  }
}
