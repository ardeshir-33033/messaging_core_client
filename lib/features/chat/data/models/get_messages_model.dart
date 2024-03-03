import 'package:messaging_core/features/chat/domain/entities/content_model.dart';

class GetMessagesModel {
  List<ContentModel> messages;
  List<ContentModel> pinnedMessages;

  GetMessagesModel({
    this.messages = const [],
    this.pinnedMessages = const [],
  });

  static GetMessagesModel fromJson(Map<String, dynamic> json) {
    return GetMessagesModel(
      messages: ContentModel.listFromJson(json["messages"]),
      pinnedMessages: ContentModel.listFromJson(json["pinned_messages"]),
    );
  }
}
