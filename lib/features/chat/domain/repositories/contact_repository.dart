import 'package:api_handler/feature/api_handler/data/models/response_model.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:dartz/dartz.dart';
import 'package:messaging_core/core/enums/receiver_type.dart';
import 'package:messaging_core/core/services/media_handler/file_model.dart';
import 'package:messaging_core/features/chat/domain/entities/content_model.dart';
import 'package:messaging_core/features/chat/domain/use_cases/get_all_chats_use_case.dart';

abstract class ContactsRepository {
  Future<Either<Exception, List<Contact>>> getAllContacts();
}
