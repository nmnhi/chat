import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:real_chat/features/contacts/domain/usecases/add_contact_usecase.dart';
import 'package:real_chat/features/contacts/domain/usecases/fetch_contacts_usecase.dart';
import 'package:real_chat/features/contacts/presentation/bloc/contacts_event.dart';
import 'package:real_chat/features/contacts/presentation/bloc/contacts_state.dart';
import 'package:real_chat/features/conversation/domain/usecases/check_or_create_conversation_use_case.dart';

class ContactsBloc extends Bloc<ContactsEvent, ContactsState> {
  final FetchContactsUsecase fetchContactsUsecase;
  final AddContactUsecase addContactUsecase;
  final CheckOrCreateConversationUseCase checkOrCreateConversationUseCase;

  ContactsBloc({
    required this.fetchContactsUsecase,
    required this.addContactUsecase,
    required this.checkOrCreateConversationUseCase,
  }) : super(ContactsInitial()) {
    on<FetchContacts>(_onFetchContacts);
    on<AddContact>(_onAddContacts);
    on<CheckOrCreateConversation>(_onCheckOrCreateConversationEvent);
  }

  Future<void> _onFetchContacts(
      FetchContacts event, Emitter<ContactsState> emit) async {
    emit(ContactsLoading());
    try {
      final contacts = await fetchContactsUsecase();
      emit(ContactsLoaded(contacts));
    } catch (e) {
      emit(ContactsError("Failed to fetch contacts"));
    }
  }

  Future<void> _onAddContacts(
      AddContact event, Emitter<ContactsState> emit) async {
    emit(ContactsLoading());

    try {
      await addContactUsecase(email: event.email);
      emit(ContactAdded());
      add(FetchContacts());
    } catch (e) {
      emit(ContactsError("Failed to add contact"));
    }
  }

  Future<void> _onCheckOrCreateConversationEvent(
      CheckOrCreateConversation event, Emitter<ContactsState> emit) async {
    try {
      emit(ContactsLoading());
      final conversationId =
          await checkOrCreateConversationUseCase(contactId: event.contactId);
      emit(ConversationReady(
          conversationId: conversationId, contactName: event.contactName));
    } catch (e) {
      emit(ContactsError("Failed to start conversation"));
    }
  }
}
