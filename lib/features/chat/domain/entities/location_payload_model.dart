import 'package:flutter/material.dart';
import 'package:messaging_core/core/enums/content_type_enum.dart';
import 'package:messaging_core/core/utils/extensions.dart';
import 'package:messaging_core/features/chat/domain/entities/content_payload_model.dart';
import 'package:messaging_core/main.dart';

class LocationPayloadModel extends ContentPayloadModel {
  double lat;
  double lng;

  LocationPayloadModel({required this.lat, required this.lng});

  @override
  ContentTypeEnum getContentType() {
    return ContentTypeEnum.location;
  }

  @override
  String shortDisplayName() {
    return "Location";
  }

  static LocationPayloadModel fromJson(Map<String, dynamic> json) {
    return LocationPayloadModel(lat: json['lat'], lng: json['lng']);
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['lat'] = lat;
    data['lng'] = lng;
    return data;
  }
}
