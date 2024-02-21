import 'package:flutter/material.dart';
import 'package:messaging_core/core/enums/content_type_enum.dart';
import 'package:messaging_core/core/enums/other_content_type_enum.dart';
import 'package:messaging_core/core/utils/extensions.dart';
import 'package:messaging_core/features/chat/domain/entities/content_payload_model.dart';
import 'package:messaging_core/main.dart';

class ContactPayloadModel extends ContentPayloadModel {
  String? contactName;
  String? contactNumber;
  ContentTypeEnum? contentType;

  ContactPayloadModel({this.contactName, this.contactNumber, this.contentType});

  ContactPayloadModel.fromJson(Map<String, dynamic> json) {
    contactName = json['contact_name'];
    contactNumber = json['contact_number'];
    if (json['content_Type'] == "null") {
      contentType = null;
    } else {
      contentType = json['content_Type'];
    }
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['contact_name'] = contactName;
    data['contact_number'] = contactNumber;
    return data;
  }

  @override
  ContentTypeEnum getContentType() {
    return ContentTypeEnum.contact;
  }

  @override
  String shortDisplayName() {
    BuildContext context = MyApp.navigatorKey.currentContext!;
    return context.l.contact;
  }
}

class OtherJsonModel {
  dynamic data;
  ContentTypeEnum? contentType;
  OtherJsonModel({this.data, this.contentType});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['data'] = data;
    json['content_Type'] = contentType.toString();
    return json;
  }
}
