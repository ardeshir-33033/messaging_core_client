import 'dart:convert';

import 'package:api_handler/feature/api_handler/data/enums/header_enum.dart';
import 'package:api_handler/feature/api_handler/data/enums/response_enum.dart';
import 'package:api_handler/feature/api_handler/data/enums/result_enums.dart';
import 'package:api_handler/feature/api_handler/data/models/query_model.dart';
import 'package:api_handler/feature/api_handler/data/models/response_model.dart';
import 'package:api_handler/feature/api_handler/presentation/presentation_usecase.dart';
import 'package:dio/dio.dart';
import 'package:messaging_core/app/api_routing/category_user/category_routing.dart';
import 'package:messaging_core/app/api_routing/chat_group/chat_group_routing.dart';
import 'package:messaging_core/app/api_routing/message/message_routing.dart';
import 'package:messaging_core/core/app_states/app_global_data.dart';
import 'package:messaging_core/core/enums/receiver_type.dart';
import 'package:messaging_core/core/services/media_handler/file_model.dart';
import 'package:messaging_core/features/chat/data/models/users_groups_category.dart';
import 'package:messaging_core/features/chat/domain/entities/content_model.dart';
import 'package:messaging_core/features/chat/domain/entities/group_model.dart';
import 'package:http/http.dart' as http;

abstract class ChatDataSource {
  Future<ResponseModel> getUsersInCategory();
  Future<ResponseModel> getGroupChatsInCategory();
  Future<ResponseModel> showMessagesInGroup(
      ReceiverType receiverType, int? senderId, int receiverId);
  Future<ResponseModel> sendMessages(
      ContentModel contentModel, FileModel? file);
}

class ChatDataSourceImpl extends ChatDataSource {
  APIHandler api;

  ChatDataSourceImpl(this.api);

  @override
  Future<ResponseModel> getUsersInCategory() async {
    ResponseModel response = await api.get(
      CategoryRouting.usersInCategory,
      queries: [
        QueryModel(name: "category_id", value: "330"),
        QueryModel(
            name: 'login_user_id', value: AppGlobalData.userId.toString())
      ],
      headerEnum: HeaderEnum.bearerHeaderEnum,
      responseEnum: ResponseEnum.responseModelEnum,
    );

    if (response.result == ResultEnum.success) {
      response.data = UsersAndGroupsInCategory.fromJson(response.data);
    }
    return response;
  }

  @override
  Future<ResponseModel> getGroupChatsInCategory() async {
    ResponseModel response = await api.get(
      ChatGroupRouting.groupChatsInCategory(99),
      queries: [QueryModel(name: "category_id", value: "330")],
      headerEnum: HeaderEnum.bearerHeaderEnum,
      responseEnum: ResponseEnum.responseModelEnum,
    );

    if (response.result == ResultEnum.success) {
      response.data = GroupModel.listFromJson(response.data);
    }
    return response;
  }

  @override
  Future<ResponseModel> showMessagesInGroup(
      ReceiverType receiverType, int? senderId, int receiverId) async {
    ResponseModel response = await api.get(
      MessageRouting.showMessages,
      queries: [
        QueryModel(
            name: "category_id", value: AppGlobalData.categoryId.toString()),
        if (senderId != null)
          QueryModel(name: "sender_id", value: senderId.toString()),
        QueryModel(name: "receiver_id", value: receiverId.toString()),
        QueryModel(name: "receiver_type", value: receiverType.name.toString()),
      ],
      headerEnum: HeaderEnum.bearerHeaderEnum,
      responseEnum: ResponseEnum.responseModelEnum,
    );

    if (response.result == ResultEnum.success) {
      response.data = ContentModel.listFromJson(response.data);
    }
    return response;
  }

  @override
  Future<ResponseModel> sendMessages(
    ContentModel contentModel,
    FileModel? file,
  ) async {
    var data = FormData.fromMap({
      if (file != null)
        'file': await MultipartFile.fromFile(file.filePath!,
            filename: file.fileName),
      'category_id': contentModel.categoryId,
      'sender_id': contentModel.senderId,
      'receiver_id': contentModel.receiverId,
      'receiver_type': contentModel.receiverType.toString(),
      'message_text': contentModel.messageText,
      'message_type': contentModel.contentType.toString()
    });

    ResponseModel response = await api.post(
      MessageRouting.sendMessages,
      body: data,
      headerEnum: HeaderEnum.bearerHeaderEnum,
      responseEnum: ResponseEnum.responseModelEnum,
    );

    if (response.result == ResultEnum.success) {
      response.data = ContentModel.fromJsonSendApi(response.data["message"]);
    }
    return response;
  }
}
