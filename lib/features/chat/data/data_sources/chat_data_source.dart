import 'package:api_handler/feature/api_handler/data/enums/header_enum.dart';
import 'package:api_handler/feature/api_handler/data/enums/response_enum.dart';
import 'package:api_handler/feature/api_handler/data/enums/result_enums.dart';
import 'package:api_handler/feature/api_handler/data/models/query_model.dart';
import 'package:api_handler/feature/api_handler/data/models/response_model.dart';
import 'package:api_handler/feature/api_handler/presentation/presentation_usecase.dart';
import 'package:messaging_core/app/api_routing/category_user/category_routing.dart';
import 'package:messaging_core/app/api_routing/chat_group/chat_group_routing.dart';
import 'package:messaging_core/features/chat/data/models/users_groups_category.dart';
import 'package:messaging_core/features/chat/domain/entities/group_model.dart';

abstract class ChatDataSource {
  Future<ResponseModel> getUsersInCategory();
  Future<ResponseModel> getGroupChatsInCategory();
}

class ChatDataSourceImpl extends ChatDataSource {
  APIHandler api;

  ChatDataSourceImpl(this.api);

  @override
  Future<ResponseModel> getUsersInCategory() async {
    ResponseModel response = await api.get(
      CategoryRouting.usersInCategory,
      queries: [QueryModel(name: "category_id", value: "330"), QueryModel(name: 'login_user_id', value: '391')],
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
}
