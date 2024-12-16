import 'package:real_chat/features/contacts/data/datasources/contacts_remote_date_source.dart';
import 'package:real_chat/features/contacts/domain/entities/contact_entity.dart';
import 'package:real_chat/features/contacts/domain/repositories/contacts_repository.dart';

class ContactsRepositoryImpl implements ContactsRepository {
  final ContactsRemoteDateSource contactsRemoteDateSource;

  ContactsRepositoryImpl({required this.contactsRemoteDateSource});

  @override
  Future<void> addContact({required String email}) async {
    await contactsRemoteDateSource.addContact(email: email);
    
  }

  @override
  Future<List<ContactEntity>> fetchContacts() async {
    return await contactsRemoteDateSource.fetchContacts();
  }
}
