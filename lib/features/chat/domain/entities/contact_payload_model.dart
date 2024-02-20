import 'package:flutter/material.dart';
import 'package:messaging_core/core/enums/content_type_enum.dart';
import 'package:messaging_core/core/enums/other_content_type_enum.dart';
import 'package:messaging_core/core/utils/extensions.dart';
import 'package:messaging_core/features/chat/domain/entities/content_payload_model.dart';
import 'package:messaging_core/main.dart';

class ContactPayloadModel extends ContentPayloadModel {
  String? contactName;
  String? contactNumber;

  ContactPayloadModel({this.contactName, this.contactNumber});

  ContactPayloadModel.fromJson(Map<String, dynamic> json) {
    contactName = json['contact_name'];
    contactNumber = json['contact_number'];
  }

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
