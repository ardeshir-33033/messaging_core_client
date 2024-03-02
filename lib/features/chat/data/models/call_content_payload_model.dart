import 'package:flutter/cupertino.dart';
import 'package:messaging_core/core/enums/content_type_enum.dart';
import 'package:messaging_core/core/utils/extensions.dart';
import 'package:messaging_core/features/chat/domain/entities/content_payload_model.dart';

class CallContentPayloadModel extends ContentPayloadModel {
  CallStatusEnum callStatus;
  CallTypeEnum callType;
  String callerUserId;
  int? durationInSeconds;
  DateTime startTime;

  CallContentPayloadModel({
    required this.callStatus,
    required this.callType,
    required this.callerUserId,
    required this.startTime,
    this.durationInSeconds,
  });

  factory CallContentPayloadModel.fromJson(Map<String, dynamic> json) =>
      CallContentPayloadModel(
        callStatus: CallStatusEnum.fromString(json["callStatusEnum"]),
        callType: CallTypeEnum.fromString(json["callType"]),
        callerUserId: json["userId"],
        durationInSeconds: json["durationInSeconds"],
        startTime: DateTime.parse(json["startTime"]),
      );

  @override
  Map<String, dynamic> toJson() {
    return {
      'callStatusEnum': callStatus.name,
      'callType': callType.name,
      'userId': callerUserId,
      'durationInSeconds': durationInSeconds,
      'contentType': ContentTypeEnum.call.name,
      "startTime": startTime.toIso8601String(),
    };
  }

  @override
  ContentTypeEnum getContentType() {
    return ContentTypeEnum.call;
  }

  @override
  String shortDisplayName() {
    return "${callStatus.name} ${callType.name} call";
  }
}

enum CallTypeEnum {
  voice,
  video;

  static CallTypeEnum fromString(String name) {
    switch (name) {
      case "voice":
        return CallTypeEnum.voice;
      case "video":
        return CallTypeEnum.video;
      default:
        return CallTypeEnum.voice;
    }
  }

  String translate(BuildContext context) {
    switch (this) {
      case CallTypeEnum.voice:
        return "Voice Call";
      case CallTypeEnum.video:
        return "Video Call";
    }
  }
}

enum CallStatusEnum {
  missed,
  rejected,
  busy,
  accepted;

  static CallStatusEnum fromString(String status) {
    switch (status) {
      case "rejected":
        return CallStatusEnum.rejected;
      case "accepted":
        return CallStatusEnum.accepted;
      case "busy":
        return CallStatusEnum.busy;
      default:
        return CallStatusEnum.missed;
    }
  }

  String translate(BuildContext context) {
    switch (this) {
      case CallStatusEnum.missed:
        return "Missed";
      case CallStatusEnum.busy:
        return "Busy";
      case CallStatusEnum.rejected:
        return "Rejected";
      case CallStatusEnum.accepted:
        return "";
    }
  }
}
