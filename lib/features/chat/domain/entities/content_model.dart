import 'package:messaging_core/core/enums/content_type_enum.dart';
import 'package:messaging_core/core/enums/message_status.dart';
import 'package:messaging_core/core/enums/receiver_type.dart';
import 'package:messaging_core/features/chat/domain/entities/category_users.dart';
import 'package:messaging_core/features/chat/domain/entities/content_payload_model.dart';

class ContentModel {
  int contentId;
  int senderId;
  ReceiverType receiverType;
  int receiverId;
  DateTime createdAt;
  DateTime updatedAt;
  int categoryId;
  String messageText;
  ContentPayloadModel contentPayload;
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
    required this.contentPayload,
    required this.messageText,
    this.isForwarded = false,
    ContentModel? repliedTo,
    required this.categoryId,
    required this.receiverId,
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
    var contentType = ContentTypeEnum.text;
    // .fromString(json['message_text'] ?? "");
    var contentPayload =
        ContentPayloadModel.create(contentType, json['message_text']);
    ContentModel? repliedTo = (mainContent && json['repliedTo'] != null)
        ? ContentModel.fromJson(json['repliedTo'], mainContent: false)
        : null;

    return ContentModel(
        contentId: json['id'],
        senderId: json['sender_id'],
        createdAt: DateTime.parse(json['created_at']),
        updatedAt: DateTime.parse(json['updated_at']),
        contentType: contentType,
        contentPayload: contentPayload,
        status: MessageStatus.sent,
        repliedTo: repliedTo,
        isForwarded: json['isForwarded'] ?? false,
        receiverType: ReceiverType.fromString(json['receiver_type']),
        messageText: json['message_text'],
        categoryId: json['category_id'],
        receiverId: json['receiver_id'],
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
      'contentPayload': contentPayload.toJson(),
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
}
