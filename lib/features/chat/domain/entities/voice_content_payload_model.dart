import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:messaging_core/core/enums/content_type_enum.dart';
import 'package:messaging_core/core/services/media_handler/voice_handler.dart';
import 'package:messaging_core/features/chat/domain/entities/content_payload_model.dart';
import 'package:messaging_core/features/chat/presentation/manager/record_voice_controller.dart';
import 'package:messaging_core/main.dart';

class VoiceContentPayloadModel extends ContentPayloadModel {
  String url;
  String? extension;
  int? durationInMilliSeconds;

  VoiceContentPayloadModel({
    required this.url,
    this.durationInMilliSeconds,
    this.extension,
  }) : super();

  VoiceContentPayloadModel.fromJson(Map<String, dynamic> json)
      : url = json['url'],
        durationInMilliSeconds = json['durationInSeconds'],
        extension =
            json['extension'] ?? RecordVoiceController.voiceRecordingFormat;

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'durationInSeconds': durationInMilliSeconds,
      'extension': extension,
      'contentType': ContentTypeEnum.voice.name,
    };
  }

  @override
  ContentTypeEnum getContentType() {
    return ContentTypeEnum.voice;
  }

  @override
  String shortDisplayName() {
    // BuildContext? context = MyApp.navigatorKey.currentContext;
    return
        // context != null
        //   ?
        getContentType().translate();
    // : "Voice Message";
  }
}
