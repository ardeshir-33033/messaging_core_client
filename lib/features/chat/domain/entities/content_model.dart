import 'package:flutter/cupertino.dart';
import 'package:messaging_core/core/app_states/app_global_data.dart';
import 'package:messaging_core/core/enums/content_type_enum.dart';
import 'package:messaging_core/core/enums/message_status.dart';
import 'package:messaging_core/core/enums/receiver_type.dart';
import 'package:messaging_core/core/utils/extensions.dart';
import 'package:messaging_core/features/chat/domain/entities/category_users.dart';
import 'package:messaging_core/features/chat/domain/entities/content_payload_model.dart';
import 'package:messaging_core/main.dart';

class ContentModel {
  int contentId;
  int senderId;
  ReceiverType receiverType;
  int receiverId;
  DateTime createdAt;
  DateTime updatedAt;
  int categoryId;
  String messageText;
  String? filePath;
  ContentPayloadModel? contentPayload;
  ContentTypeEnum contentType;
  MessageStatus status;
  ContentModel? _repliedTo; // todo possibility of forge from client
  bool isForwarded;
  CategoryUser? sender;

  set repliedTo(ContentModel? value) {
    if (value == null) {
      _repliedTo = null;
      return;
    }
    ContentModel? model = ContentModel.fromJson(
        value.toJson(mainContent: false),
        mainContent: false);
    _repliedTo = model;
  }

  ContentModel? get repliedTo => _repliedTo;

  ContentModel({
    required this.contentId,
    required this.senderId,
    required this.receiverType,
    required this.createdAt,
    required this.updatedAt,
    required this.contentType,
    this.contentPayload,
    required this.messageText,
    this.isForwarded = false,
    ContentModel? repliedTo,
    required this.categoryId,
    required this.receiverId,
    this.filePath,
    this.sender,
    this.status = MessageStatus
        .sent, // we didn't store message status on server. but keep in mind that if content is received to server, it's definitely 'sent'
  }) {
    this.repliedTo = repliedTo;
  }

  // factory ContentModel.fromContentTable(ContentTableData data) => ContentModel(
  //       channelId: data.channelId,
  //       timestamp: data.timestamp,
  //       contentType: data.contentPayload.getContentType(),
  //       contentPayload: data.contentPayload,
  //       senderId: data.senderId,
  //       sequenceNumber: data.sequenceNumber,
  //       contentId: data.contentId,
  //       repliedTo: data.repliedTo,
  //       isForwarded: data.isForwarded,
  //       status: data.status,
  //     );
  //
  // ContentTableData toContentTableData() => ContentTableData(
  //       status: status,
  //       isForwarded: isForwarded,
  //       repliedTo: repliedTo,
  //       contentId: contentId,
  //       sequenceNumber: sequenceNumber,
  //       senderId: senderId,
  //       contentPayload: contentPayload,
  //       contentType: contentType,
  //       timestamp: timestamp,
  //       channelId: channelId,
  //     );

  static ContentModel fromJson(Map<String, dynamic> json,
      {bool mainContent = true}) {
    var contentType = ContentTypeEnum.fromString(json['message_type'] ?? "");
    var contentPayload =
        ContentPayloadModel.create(contentType, json['message_text']);
    ContentModel? repliedTo = (mainContent && json['repliedTo'] != null)
        ? ContentModel.fromJson(json['repliedTo'], mainContent: false)
        : null;

    return ContentModel(
        contentId: json['id'],
        senderId: json['sender_id'],
        createdAt: DateTime.parse(json['created_at']).toLocal(),
        updatedAt: DateTime.parse(json['updated_at']).toLocal(),
        contentType: contentType,
        contentPayload: contentPayload,
        status: MessageStatus.sent,
        repliedTo: repliedTo,
        isForwarded: json['isForwarded'] ?? false,
        receiverType: ReceiverType.fromString(json['receiver_type']),
        messageText: json['message_text'],
        categoryId: json['category_id'],
        receiverId: json['receiver_id'],
        filePath: json['file_path'],
        sender: json['sender'] != null
            ? CategoryUser.fromJson(json['sender'])
            : null);
  }

  static ContentModel fromSocketJson(Map<String, dynamic> json,
      {bool mainContent = true}) {
    var contentType = ContentTypeEnum.fromString(json['messageType'] ?? "text");
    // var contentPayload =
    //     ContentPayloadModel.create(contentType, json['text']);
    ContentModel? repliedTo = (mainContent && json['repliedTo'] != null)
        ? ContentModel.fromJson(json['repliedTo'], mainContent: false)
        : null;

    return ContentModel(
        contentId: json['messageId'],
        senderId: json['senderId'],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        contentType: contentType,
        // contentPayload: contentPayload,
        status: MessageStatus.sent,
        repliedTo: repliedTo,
        isForwarded: json['isForwarded'] ?? false,
        receiverType: ReceiverType.fromString(json['receiverType']),
        messageText: json['text'],
        categoryId: AppGlobalData.categoryId,
        receiverId: json['receiverId'],
        filePath: json['file_path'],
        sender: json['sender'] != null
            ? CategoryUser.fromJson(json['sender'])
            : null);
  }

  static ContentModel fromJsonSendApi(Map<String, dynamic> json,
      {bool mainContent = true}) {
    var contentType = ContentTypeEnum.text;
    // .fromString(json['message_text'] ?? "");
    var contentPayload =
        ContentPayloadModel.create(contentType, json['message_text']);
    ContentModel? repliedTo = (mainContent && json['repliedTo'] != null)
        ? ContentModel.fromJson(json['repliedTo'], mainContent: false)
        : null;

    return ContentModel(
        contentId: json['id'],
        senderId: int.parse(json['sender_id']),
        createdAt: DateTime.parse(json['created_at']).toLocal(),
        updatedAt: DateTime.parse(json['updated_at']).toLocal(),
        contentType: contentType,
        contentPayload: contentPayload,
        status: MessageStatus.sent,
        repliedTo: repliedTo,
        isForwarded: json['isForwarded'] ?? false,
        receiverType: ReceiverType.fromString(json['receiver_type']),
        messageText: json['message_text'],
        categoryId: int.parse(json['category_id']),
        receiverId: int.parse(json['receiver_id']),
        filePath: json['file_path'],
        sender: json['sender'] != null
            ? CategoryUser.fromJson(json['sender'])
            : null);
  }

  toJson({bool mainContent = true}) {
    var json = {
      'contentId': contentId,
      'senderId': senderId,
      'updated_at': updatedAt.millisecondsSinceEpoch,
      'created_at': createdAt.millisecondsSinceEpoch,
      'contentPayload': contentPayload?.toJson(),
      'contentType': contentType.name,
      'status': status.name,
      'isForwarded': isForwarded,
    };
    if (_repliedTo != null && mainContent) {
      json['repliedTo'] = _repliedTo?.toJson(mainContent: false);
    }
    return json;
  }

  static List<ContentModel> listFromJson(dynamic json) {
    if (json != null) {
      return json.map<ContentModel>((j) {
        return ContentModel.fromJson(j);
      }).toList();
    }
    return [];
  }

  static List<ContentModel> listFromJsonSendApi(dynamic json) {
    if (json != null) {
      return json.map<ContentModel>((j) {
        return ContentModel.fromJsonSendApi(j);
      }).toList();
    }
    return [];
  }

  shortDisplayMessage() {
    BuildContext context = MyApp.navigatorKey.currentContext!;
    switch (contentType) {
      case ContentTypeEnum.voice:
        return context.l.voiceMessage;
      case ContentTypeEnum.text:
        return messageText;
      case ContentTypeEnum.image:
        return context.l.image;
      case ContentTypeEnum.video:
        return context.l.video;
      case ContentTypeEnum.gif:
        return context.l.gif;
      default:
        return messageText;
    }
  }
}
