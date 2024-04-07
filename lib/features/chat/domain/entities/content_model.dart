import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:messaging_core/core/app_states/app_global_data.dart';
import 'package:messaging_core/core/enums/content_type_enum.dart';
import 'package:messaging_core/core/enums/message_status.dart';
import 'package:messaging_core/core/enums/receiver_type.dart';
import 'package:messaging_core/core/storage/database.dart';
import 'package:messaging_core/core/utils/extensions.dart';
import 'package:messaging_core/features/chat/data/models/reaction_model.dart';
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
  DateTime? readAt;
  int categoryId;
  int pinned;
  String messageText;
  String? filePath;
  ContentPayloadModel? contentPayload;
  ContentTypeEnum contentType;
  MessageStatus status;
  ContentModel? replied; // todo possibility of forge from client
  bool isForwarded;
  CategoryUser? sender;
  List<ReactionModel>? reactionModel;

  ContentModel({
    required this.contentId,
    required this.senderId,
    required this.receiverType,
    required this.createdAt,
    required this.updatedAt,
    required this.pinned,
    this.readAt,
    required this.contentType,
    this.contentPayload,
    required this.messageText,
    this.isForwarded = false,
    this.replied,
    required this.categoryId,
    required this.receiverId,
    this.reactionModel,
    this.filePath,
    this.sender,
    this.status = MessageStatus
        .sent, // we didn't store message status on server. but keep in mind that if content is received to server, it's definitely 'sent'
  });

  factory ContentModel.fromMessagesTable(MessageTableData data) {
    var contentType = ContentTypeEnum.fromString(data.messageType);
    var contentPayload =
        ContentPayloadModel.create(contentType, data.messageText);

    return ContentModel(
        contentId: data.id,
        receiverId: data.receiverId,
        contentType: ContentTypeEnum.fromString(data.messageType),
        contentPayload: contentPayload,
        senderId: data.senderId,
        pinned: data.pinned,
        messageText: data.messageText,
        receiverType: ReceiverType.fromString(data.receiverType),
        categoryId: data.categoryId,
        isForwarded: data.isForwarded,
        createdAt: data.createdAt,
        updatedAt: data.updatedAt,
        filePath: data.filePath,
        replied: data.replied != null
            ? ContentModel.fromJson(jsonDecode(data.replied!))
            : null,
        readAt: data.readedAt,
        sender: data.sender != null
            ? CategoryUser.fromJson(jsonDecode(data.sender!))
            : null);
  }

  MessageTableData toMessagesTableData(String roomIdentifier) =>
      MessageTableData(
          roomIdentifier: roomIdentifier,
          id: contentId,
          receiverId: receiverId,
          categoryId: categoryId,
          receiverType: receiverType.name,
          messageText: messageText,
          senderId: senderId,
          pinned: pinned,
          replied: replied != null ? jsonEncode(replied!.toJson()) : null,
          messageType: contentType.name,
          isForwarded: isForwarded,
          filePath: filePath,
          createdAt: createdAt,
          updatedAt: updatedAt,
          readedAt: readAt,
          sender: sender != null ? jsonEncode(sender!.toJson()) : null);

  static ContentModel fromJson(Map<String, dynamic> json,
      {bool mainContent = true}) {
    var contentType = ContentTypeEnum.fromString(json['message_type'] ?? "");
    var contentPayload =
        ContentPayloadModel.create(contentType, json['message_text']);
    ContentModel? reply = (json['reply'] != null)
        ? ContentModel.fromJson(json['reply'], mainContent: false)
        : null;

    return ContentModel(
        contentId: json['id'],
        senderId: json['sender_id'],
        createdAt: DateTime.parse(json['created_at']).toLocal(),
        updatedAt: DateTime.parse(json['updated_at']).toLocal(),
        readAt: json['readed_at'] != null
            ? DateTime.parse(json['readed_at']).toLocal()
            : null,
        contentType: contentType,
        contentPayload: contentPayload,
        status: MessageStatus.sent,
        reactionModel: json['readed_at'] != null
            ? ReactionModel.listFromJson(json["reactions"])
            : null,
        pinned: json["pinned"],
        replied: reply,
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
    var contentPayload = ContentPayloadModel.create(contentType, json['text']);
    ContentModel? reply = (mainContent && json['reply'] != null)
        ? ContentModel.fromJson(json['reply'], mainContent: false)
        : null;

    return ContentModel(
        contentId: json['messageId'],
        senderId: json['senderId'],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        // readAt: json['readed_at'] != null
        //     ? DateTime.parse(json['readed_at']).toLocal()
        //     : null,
        contentType: contentType,
        contentPayload: contentPayload,
        status: MessageStatus.sent,
        replied: reply,
        pinned: json["pinned"] ?? 0,
        reactionModel: json['readed_at'] != null
            ? ReactionModel.listFromJson(json["reactions"])
            : null,
        isForwarded: json['isForwarded'] ?? false,
        receiverType: ReceiverType.fromString(json['receiverType']),
        messageText: json['text'],
        categoryId: AppGlobalData.categoryId,
        receiverId: json['receiverId'].runtimeType == int
            ? json['receiverId']
            : int.parse(json['receiverId']),
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
    // ContentModel? reply = (mainContent && json['reply'] != null)
    //     ? ContentModel.fromJson(json['reply'], mainContent: false)
    //     : null;

    return ContentModel(
        contentId: json['id'],
        senderId: int.parse(json['sender_id']),
        createdAt: DateTime.parse(json['created_at']).toLocal(),
        updatedAt: DateTime.parse(json['updated_at']).toLocal(),
        readAt: json['readed_at'] != null
            ? DateTime.parse(json['readed_at']).toLocal()
            : null,
        reactionModel: json['readed_at'] != null
            ? ReactionModel.listFromJson(json["reactions"])
            : null,
        contentType: contentType,
        contentPayload: contentPayload,
        status: MessageStatus.sent,
        // replied: reply,
        pinned: json["replied"] == null ? 0 : json["replied"],
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
      'id': contentId,
      'sender_id': senderId,
      'receiver_id': receiverId,
      'receiver_type': receiverType.name,
      'updated_at': updatedAt.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'contentPayload': contentPayload?.toJson(),
      'message_type': contentType.name,
      'status': status.name,
      'isForwarded': isForwarded,
      'readed_at': readAt != null ? readAt!.toIso8601String() : null,
      'reactions': reactionModel?.map((v) => v.toJson()).toList(),
      'message_text': contentType == ContentTypeEnum.other
          ? contentPayload!.toJson()
          : messageText.toString(),
      'category_id': categoryId,
      'file_path': filePath,
      'pinned': pinned,
    };
    if (replied != null && mainContent) {
      json['replied'] = replied?.toJson(mainContent: false);
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
    // BuildContext context = MyApp.navigatorKey.currentContext!;
    switch (contentType) {
      case ContentTypeEnum.voice:
        return "Voice Message";
      case ContentTypeEnum.text:
        return messageText;
      case ContentTypeEnum.image:
        return "Image";
      case ContentTypeEnum.video:
        return "Video";
      case ContentTypeEnum.gif:
        return "Gif";
      case ContentTypeEnum.other:
        return "Contact";
      default:
        return messageText;
    }
  }
}
