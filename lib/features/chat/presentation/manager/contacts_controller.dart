import 'package:contacts_service/contacts_service.dart';
import 'package:get/get.dart';
import 'package:messaging_core/core/app_states/result_state.dart';
import 'package:messaging_core/features/chat/domain/use_cases/get_contacts_use_case.dart';

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
}
