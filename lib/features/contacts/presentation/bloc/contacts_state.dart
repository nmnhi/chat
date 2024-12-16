import 'package:real_chat/features/contacts/domain/entities/contact_entity.dart';

abstract class ContactsState {}

class ContactsInitial extends ContactsState {}

class ContactsLoading extends ContactsState {}

class ContactsLoaded extends ContactsState {
  final List<ContactEntity> contacts;

  ContactsLoaded(this.contacts);
}

class ContactsError extends ContactsState {
  final String error;

  ContactsError(this.error);
}

class ContactAdded extends ContactsState {}

class ConversationReady extends ContactsState {
  final String conversationId;
  final String contactName;

  ConversationReady({required this.conversationId, required this.contactName});
}
