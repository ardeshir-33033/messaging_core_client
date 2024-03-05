import 'package:api_handler/api_handler.dart';
import 'package:api_handler/feature/api_handler/data/models/response_model.dart';
import 'package:messaging_core/core/enums/receiver_type.dart';
import 'package:messaging_core/core/services/media_handler/file_model.dart';
import 'package:messaging_core/features/chat/data/models/users_groups_category.dart';
import 'package:messaging_core/features/chat/domain/entities/chats_parent_model.dart';
import 'package:messaging_core/features/chat/domain/entities/content_model.dart';
import 'package:messaging_core/features/chat/domain/repositories/chat_repository.dart';
import 'package:messaging_core/features/chat/domain/repositories/storage/chat_storage_repository.dart';
import 'package:messaging_core/features/chat/presentation/manager/connection_status_controller.dart';
import 'package:messaging_core/locator.dart';

import '../data_sources/chat_data_source.dart';

class ChatRepositoryImpl extends ChatRepository {
  final ChatDataSource _chatDataSource;
  final ChatStorageRepository _chatStorageRepository;

  ChatRepositoryImpl(this._chatDataSource, this._chatStorageRepository);

  @override
  Future<ResponseModel> getAllChats() async {
    try {
      List<ChatParentClass> chats = [];
      if (locator<ConnectionStatusProvider>().isConnected) {
        ResponseModel response = await _chatDataSource.getUsersInCategory();

        UsersAndGroupsInCategory usersAndGroupsInCategory = response.data;

        chats.addAll(usersAndGroupsInCategory.users);
        chats.addAll(usersAndGroupsInCategory.groups);

        chats.sort((a, b) => ((b.updatedAt ?? b.lastMessage?.updatedAt) ??
                DateTime(1998))
            .compareTo(
                ((a.updatedAt ?? a.lastMessage?.updatedAt) ?? DateTime(1998))));
        _chatStorageRepository.saveChats(chats);

        return response;
      } else {
        chats = await _chatStorageRepository.getChats();
        return ResponseModel(
          data: chats,
          result: ResultEnum.success,
        );
      }
    } catch (e) {
      return ResponseModel(
        statusCode: 510,
        result: ResultEnum.error,
        message: e.toString(),
      );
    }
  }

  @override
  Future<ResponseModel> getMessages(
      ReceiverType receiverType, int? senderId, int receiverId) async {
    try {
      return await _chatDataSource.showMessagesInGroup(
          receiverType, senderId, receiverId);
    } catch (e) {
      return ResponseModel(
        statusCode: 510,
        result: ResultEnum.error,
        message: e.toString(),
      );
    }
  }

  @override
  sendMessages(ContentModel contentModel, FileModel? file) async {
    try {
      return await _chatDataSource.sendMessages(contentModel, file);
    } catch (e) {
      return ResponseModel(
        statusCode: 510,
        result: ResultEnum.error,
        message: e.toString(),
      );
    }
  }

  @override
  Future<ResponseModel> editMessages(String newText, int messageId) async {
    try {
      return await _chatDataSource.editMessages(newText, messageId);
    } catch (e) {
      return ResponseModel(
        statusCode: 510,
        result: ResultEnum.error,
        message: e.toString(),
      );
    }
  }

  @override
  Future<ResponseModel> createGroup(
      String groupName, List<int> users, FileModel? file) async {
    try {
      return await _chatDataSource.createGroup(groupName, users, file);
    } catch (e) {
      return ResponseModel(
        statusCode: 510,
        result: ResultEnum.error,
        message: e.toString(),
      );
    }
  }

  @override
  Future<ResponseModel> editGroup(
      String groupName, List<int> users, int groupId, FileModel? file) async {
    try {
      return await _chatDataSource.editGroup(groupName, users, groupId, file);
    } catch (e) {
      return ResponseModel(
        statusCode: 510,
        result: ResultEnum.error,
        message: e.toString(),
      );
    }
  }

  @override
  Future<ResponseModel> deleteMessage(int messageId) async {
    try {
      return await _chatDataSource.deleteMessage(messageId);
    } catch (e) {
      return ResponseModel(
        statusCode: 510,
        result: ResultEnum.error,
        message: e.toString(),
      );
    }
  }

  @override
  Future<ResponseModel> pinMessage(int messageId) async {
    try {
      return await _chatDataSource.pinMessage(messageId);
    } catch (e) {
      return ResponseModel(
        statusCode: 510,
        result: ResultEnum.error,
        message: e.toString(),
      );
    }
  }

  @override
  Future<bool> updateRead(int messageId) async {
    try {
      return await _chatDataSource.updateReadStatus(messageId);
    } catch (e) {
      return false;
    }
  }
}
