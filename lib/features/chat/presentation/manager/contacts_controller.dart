import 'dart:convert';

import 'package:contacts_service/contacts_service.dart';
import 'package:get/get.dart';
import 'package:messaging_core/core/app_states/result_state.dart';
import 'package:messaging_core/core/enums/content_type_enum.dart';
import 'package:messaging_core/features/chat/domain/entities/contact_payload_model.dart';
import 'package:messaging_core/features/chat/domain/use_cases/get_contacts_use_case.dart';

import '../../../../locator.dart';
import 'chat_controller.dart';

class ContactsController extends GetxController {
  final GetContactsUseCase getContactsUseCase;

  ContactsController(this.getContactsUseCase);

  List<Contact>? contacts;
  RequestStatus getContactsStatus = RequestStatus();

  getAllContacts() async {
    getContactsStatus.loading();
    update(["contacts"]);
    final response = await getContactsUseCase(null);
    response.fold((exception) {
      getContactsStatus.error(exception.toString());
      update(["contacts"]);
    }, (contactsMap) {
      contacts = contactsMap;
      getContactsStatus.success();
      update(["contacts"]);
    });
  }

  sendContactAsMessage(Contact selectedContact, int chatId) {
    final ChatController controller = locator<ChatController>();

    ContactPayloadModel contact = ContactPayloadModel(
      contactName: selectedContact.displayName,
      contactNumber: selectedContact.phones!.first.value,
    );
    OtherJsonModel jsonModel = OtherJsonModel(
        data: contact.toJson(), contentType: ContentTypeEnum.contact);

    controller.attachContact(
        text: jsonEncode(jsonModel.toJson()),
        content: contact,
        contentType: ContentTypeEnum.other,
        receiverId: chatId);
  }
}
