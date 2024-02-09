import 'package:api_handler/feature/api_handler/data/enums/header_enum.dart';
import 'package:api_handler/feature/api_handler/data/enums/response_enum.dart';
import 'package:api_handler/feature/api_handler/data/enums/result_enums.dart';
import 'package:api_handler/feature/api_handler/data/models/query_model.dart';
import 'package:api_handler/feature/api_handler/data/models/response_model.dart';
import 'package:api_handler/feature/api_handler/presentation/presentation_usecase.dart';
import 'package:messaging_core/app/api_routing/category_user/category_routing.dart';
import 'package:messaging_core/app/api_routing/chat_group/chat_group_routing.dart';
import 'package:messaging_core/app/api_routing/message/message_routing.dart';
import 'package:messaging_core/core/enums/receiver_type.dart';
import 'package:messaging_core/features/chat/data/models/users_groups_category.dart';
import 'package:messaging_core/features/chat/domain/entities/content_model.dart';
import 'package:messaging_core/features/chat/domain/entities/group_model.dart';

abstract class ChatDataSource {
  Future<ResponseModel> getUsersInCategory();
  Future<ResponseModel> getGroupChatsInCategory();
  Future<ResponseModel> showMessagesInGroup(
      ReceiverType receiverType, int senderId, int receiverId);
  Future<ResponseModel> sendMessages(
      ContentModel contentModel, List<String> receivingUsers);
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
        QueryModel(name: 'login_user_id', value: '391')
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
      ReceiverType receiverType, int senderId, int receiverId) async {
    ResponseModel response = await api.get(
      MessageRouting.showMessages,
      queries: [
        QueryModel(name: "category_id", value: "330"),
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
      ContentModel contentModel, List<String> receivingUsers) async {
    ResponseModel response = await api.get(
      MessageRouting.sendMessages,
      headerEnum: HeaderEnum.bearerHeaderEnum,
      responseEnum: ResponseEnum.responseModelEnum,
    );

    if (response.result == ResultEnum.success) {
      response.data = ContentModel.listFromJsonSendApi(response.data);
    }
    return response;
  }
}
