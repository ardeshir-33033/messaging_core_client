import 'package:contacts_service/contacts_service.dart';
import 'package:dartz/dartz.dart';
import 'package:messaging_core/core/usecase/usecase.dart';
import 'package:messaging_core/features/chat/domain/repositories/contact_repository.dart';

class GetContactsUseCase
    implements UseCase<Future<Either<Exception, List<Contact>>>, void> {
  final ContactsRepository _contactsRepository;

  GetContactsUseCase(this._contactsRepository);

  @override
  Future<Either<Exception, List<Contact>>> call(void params) async {
    return await _contactsRepository.getAllContacts();
  }
}
