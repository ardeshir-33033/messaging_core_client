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
import 'package:messaging_core/core/enums/content_type_enum.dart';
import 'package:messaging_core/core/enums/receiver_type.dart';
import 'package:messaging_core/core/services/media_handler/file_model.dart';
import 'package:messaging_core/features/chat/data/models/create_group_model.dart';
import 'package:messaging_core/features/chat/data/models/get_messages_model.dart';
import 'package:messaging_core/features/chat/data/models/users_groups_category.dart';
import 'package:messaging_core/features/chat/domain/entities/content_model.dart';
import 'package:messaging_core/features/chat/domain/entities/group_model.dart';
import 'package:http/http.dart' as http;
import 'package:messaging_core/features/chat/presentation/manager/connection_status_controller.dart';
import 'package:messaging_core/locator.dart';

abstract class ChatDataSource {
  Future<ResponseModel> getUsersInCategory();
  Future<ResponseModel> getGroupChatsInCategory();
  Future<ResponseModel> showMessagesInGroup(
      ReceiverType receiverType, int? senderId, int receiverId);
  Future<ResponseModel> sendMessages(
      ContentModel contentModel, FileModel? file);
  Future<ResponseModel> editMessages(String newText, int messageId);
  Future<ResponseModel> createGroup(
      String groupName, List<int> users, FileModel? file);
  Future<ResponseModel> editGroup(
      String groupName, List<int> users, int groupId, FileModel? file);
  Future<ResponseModel> deleteMessage(int messageId);
  Future<String> generateAgoraToken(String roomIdentifier);
  Future<bool> updateReadStatus(int messageId);
  Future<ResponseModel> pinMessage(int messageId, bool pin);

  void loginSiamak();
}

class ChatDataSourceImpl extends ChatDataSource {
  APIHandler api;

  ChatDataSourceImpl(this.api);

  @override
  Future<ResponseModel> getUsersInCategory() async {
    ResponseModel response = await api.get(
      CategoryRouting.usersInCategory,
      queries: [
        QueryModel(
            name: "category_id", value: AppGlobalData.categoryId.toString()),
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
      response.data = GetMessagesModel.fromJson(response
          .data); // response.data = ContentModel.listFromJson(response.data["messages"]);
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
      if (contentModel.replied != null)
        'parent_id': contentModel.replied!.contentId,
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

  @override
  Future<ResponseModel> editMessages(String newText, int messageId) async {
    var data = FormData.fromMap({
      'message_text': newText,
      'message_type': ContentTypeEnum.text.toString(),
      '_method': 'PUT'
    });

    ResponseModel response = await api.post(
      MessageRouting.editMessages(messageId.toString()),
      body: data,
      headerEnum: HeaderEnum.bearerHeaderEnum,
      responseEnum: ResponseEnum.responseModelEnum,
    );

    return response;
  }

  @override
  Future<ResponseModel> createGroup(
      String groupName, List<int> users, FileModel? file) async {
    var data = FormData.fromMap({
      if (file != null)
        'file': await MultipartFile.fromFile(file.filePath!,
            filename: file.fileName),
      'name': groupName,
      'users': users,
      'category_id': AppGlobalData.categoryId,
      'creator_user_id': AppGlobalData.userId,
    }, ListFormat.multiCompatible);

    ResponseModel response = await api.post(
      ChatGroupRouting.createChat,
      body: data,
      headerEnum: HeaderEnum.bearerHeaderEnum,
      responseEnum: ResponseEnum.responseModelEnum,
    );

    if (response.result == ResultEnum.success) {
      response.data = CreateGroupModel.fromJson(response.data);
    }
    return response;
  }

  @override
  Future<ResponseModel> editGroup(
      String groupName, List<int> users, int groupId, FileModel? file) async {
    var data = FormData.fromMap({
      if (file != null)
        'file': await MultipartFile.fromFile(file.filePath!,
            filename: file.fileName),
      'name': groupName,
      'users': users,
      'category_id': AppGlobalData.categoryId,
      'creator_user_id': AppGlobalData.userId,
      '_method': 'PUT'
    }, ListFormat.multiCompatible);

    ResponseModel response = await api.post(
      ChatGroupRouting.editGroup(groupId),
      body: data,
      headerEnum: HeaderEnum.bearerHeaderEnum,
      responseEnum: ResponseEnum.responseModelEnum,
    );

    if (response.result == ResultEnum.success) {
      response.data = CreateGroupModel.fromJson(response.data);
    }
    return response;
  }

  @override
  Future<bool> updateReadStatus(int messageId) async {
    var data = {
      'messageId': messageId,
      'userId': AppGlobalData.userId,
      '_method': 'PUT'
    };
    ResponseModel response = await api.post(
      MessageRouting.updateRead,
      body: data,
      headerEnum: HeaderEnum.bearerHeaderEnum,
      responseEnum: ResponseEnum.responseModelEnum,
    );

    if (response.result == ResultEnum.success) {
      return true;
    }
    return false;
  }

  @override
  Future<ResponseModel> deleteMessage(int messageId) async {
    // api.setToken("56|lvhEN6AQjiI1x9wArHO412jjbIlBiBavYofDpXjg");

    ResponseModel response = await api.delete(
      MessageRouting.deleteMessages(messageId.toString()),
      headerEnum: HeaderEnum.bearerHeaderEnum,
      responseEnum: ResponseEnum.responseModelEnum,
    );

    return response;
  }

  @override
  Future<ResponseModel> pinMessage(int messageId, bool pin) async {
    var data = {
      'messageId': messageId.toString(),
      'pinned': pin ? 1 : 0,
      '_method': 'PUT'
    };

    ResponseModel response = await api.post(
      MessageRouting.pinMessages,
      body: data,
      headerEnum: HeaderEnum.bearerHeaderEnum,
      responseEnum: ResponseEnum.responseModelEnum,
    );

    if (response.result == ResultEnum.success) {
      response.data = ContentModel.listFromJson(response.data);
    }
    return response;
  }

  @override
  Future<String> generateAgoraToken(String roomIdentifier) async {
    var data = {
      'channelName': roomIdentifier,
      'userId': AppGlobalData.userId.toString()
    };
    var headers = {'Content-Type': 'application/x-www-form-urlencoded'};
    var dio = Dio();
    var response = await dio.request(
      MessageRouting.agoraToken,
      options: Options(
        method: 'POST',
        headers: headers,
      ),
      data: data,
    );

    return response.data["token"];
  }

  loginSiamak() async {
    if (locator<ConnectionStatusProvider>().isConnected) {
      var headers = {'Content-Type': 'application/x-www-form-urlencoded'};
      var data = {'username': 'Siamak', 'password': 'Sia123456'};

      if (AppGlobalData.userId != 391) {
        data = {'username': AppGlobalData.userName, 'password': '1234sr'};
      }
      var dio = Dio();
      var response = await dio.request(
        'https://zoomiran.com/api/v1/login',
        options: Options(
          method: 'POST',
          headers: headers,
        ),
        data: data,
      );

      if (response.statusCode == 200) {
        api.setToken(response.data["data"]["token"]);
      } else {
        print(response.statusMessage);
      }
    }
  }
}
