import 'package:messaging_core/core/enums/change_message_modes.dart';
import 'package:messaging_core/features/chat/data/models/create_group_model.dart';

class ChangeMessageModel {
  String roomIdentifier;
  int senderId;
  int categoryId;
  int messageId;
  ChangeMessageEnum mode;
  String? data;

  ChangeMessageModel({
    required this.roomIdentifier,
    required this.senderId,
    required this.categoryId,
    required this.messageId,
    required this.mode,
    this.data,
  });

  static ChangeMessageModel fromJson(Map<String, dynamic> json) {
    return ChangeMessageModel(
        roomIdentifier: json['roomIdentifier'],
        senderId: json['senderId'],
        categoryId: json['categoryId'],
        messageId: json['messageId'],
        mode: ChangeMessageEnum.fromString(json['mode']),
        data: json['data']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['roomIdentifier'] = roomIdentifier;
    data['senderId'] = senderId;
    data['categoryId'] = categoryId;
    data['messageId'] = messageId;
    data['data'] = this.data;
    data['mode'] = mode.toString();

    return data;
  }
}
