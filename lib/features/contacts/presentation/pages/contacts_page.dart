import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:real_chat/features/chat/presentation/pages/chat_page.dart';
import 'package:real_chat/features/contacts/presentation/bloc/contacts_bloc.dart';
import 'package:real_chat/features/contacts/presentation/bloc/contacts_event.dart';
import 'package:real_chat/features/contacts/presentation/bloc/contacts_state.dart';

class ContactsPage extends StatefulWidget {
  const ContactsPage({super.key});

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<ContactsBloc>(context).add(FetchContacts());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        title: Text(
          "Contacts",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: BlocConsumer<ContactsBloc, ContactsState>(
        listener: (context, state) async {
          final contactsBloc = BlocProvider.of<ContactsBloc>(context);
          if (state is ConversationReady) {
            var res = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatPage(
                  conversationId: state.conversationId,
                  mate: state.contactName,
                ),
              ),
            );
            if (res == null) {
              contactsBloc.add(FetchContacts());
            }
          }
        },
        builder: (context, state) {
          if (state is ContactsLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is ContactsLoaded) {
            return ListView.builder(
              itemCount: state.contacts.length,
              itemBuilder: (context, index) {
                final contact = state.contacts[index];
                return ListTile(
                  title: Text(
                    contact.username,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  subtitle: Text(
                    contact.email,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  onTap: () {
                    BlocProvider.of<ContactsBloc>(context).add(
                      CheckOrCreateConversation(
                        contactId: contact.id,
                        contactName: contact.username,
                      ),
                    );
                  },
                );
              },
            );
          } else if (state is ContactsError) {
            return Center(
              child: Text(state.error),
            );
          }
          return Center(
            child: Text("No contacts found"),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddContactDialog(context),
        child: Icon(Icons.add),
      ),
    );
  }

  void _showAddContactDialog(BuildContext context) {
    final emailController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          "Add Contact",
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        content: TextField(
          controller: emailController,
          decoration: InputDecoration(
            hintText: "Enter contact email",
            hintStyle: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              final email = emailController.text.trim();
              if (email.isNotEmpty) {
                BlocProvider.of<ContactsBloc>(context).add(
                  AddContact(email: email),
                );
                Navigator.pop(context);
              }
            },
            child: Text(
              "Add",
            ),
          )
        ],
      ),
    );
  }
}
