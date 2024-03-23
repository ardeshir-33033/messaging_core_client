import 'package:api_handler/feature/api_handler/data/models/response_model.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:dartz/dartz.dart';
import 'package:messaging_core/core/error/exceptions.dart';
import 'package:messaging_core/core/utils/extensions.dart';
import 'package:messaging_core/features/chat/domain/repositories/contact_repository.dart';
import 'package:messaging_core/main.dart';
import 'package:permission_handler/permission_handler.dart';

class ContactRepositoryImpl extends ContactsRepository {
  @override
  Future<Either<Exception, List<Contact>>> getAllContacts() async {
    try {
      bool hasPermission = (await Permission.contacts.request()).isGranted;
      if (hasPermission == false) {
        return left(PermissionException("Permission To Access Contact Denied"));
      }
      List<Contact> contactMap = await _getPhoneContacts();

      return right(contactMap);
    } catch (error) {
      if (error is Exception) {
        return left(error);
      }
      return left(DefaultException());
    }
  }

  Future<List<Contact>> _getPhoneContacts() async {
    List<Contact> phoneContacts = await ContactsService.getContacts(
        withThumbnails: false,
        iOSLocalizedLabels: false,
        photoHighResolution: false,
        orderByGivenName: false,
        androidLocalizedLabels: false);

    return phoneContacts;
  }
}
