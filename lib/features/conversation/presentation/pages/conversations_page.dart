import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:real_chat/core/theme.dart';
import 'package:real_chat/features/chat/presentation/pages/chat_page.dart';
import 'package:real_chat/features/contacts/presentation/pages/contacts_page.dart';
import 'package:real_chat/features/conversation/presentation/bloc/conversations_bloc.dart';
import 'package:real_chat/features/conversation/presentation/bloc/conversations_event.dart';
import 'package:real_chat/features/conversation/presentation/bloc/conversations_state.dart';

class ConversationsPage extends StatefulWidget {
  const ConversationsPage({super.key});

  @override
  State<ConversationsPage> createState() => _ConversationsPageState();
}

class _ConversationsPageState extends State<ConversationsPage> {
  @override
  void initState() {
    BlocProvider.of<ConversationsBloc>(context).add(FetchConversations());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Message",
          style: Theme.of(context).textTheme.titleLarge,
        ),
        centerTitle: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 70,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.search,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Text(
              "Recent",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            height: 100,
            padding: const EdgeInsets.all(5),
            child: BlocBuilder<ConversationsBloc, ConversationsState>(
              builder: (context, state) {
                if (state is ConversationsLoading) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is ConversationsLoaded) {
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: state.conversations.length,
                    itemBuilder: (context, index) {
                      final conversation = state.conversations[index];
                      return _buildRecentContact(
                          conversation.participantName, context);
                    },
                  );
                } else if (state is ConversationsError) {
                  return Center(
                    child: Text(state.message),
                  );
                }
                return Center(
                  child: Text("Empty data"),
                );
              },
            ),
          ),
          const SizedBox(height: 15),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: DefaultColors.messageListPage,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                ),
              ),
              padding: const EdgeInsets.only(top: 12),
              child: BlocBuilder<ConversationsBloc, ConversationsState>(
                builder: (context, state) {
                  if (state is ConversationsLoading) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is ConversationsLoaded) {
                    return ListView.builder(
                      itemCount: state.conversations.length,
                      itemBuilder: (context, index) {
                        final conversation = state.conversations[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChatPage(
                                  conversationId: conversation.id,
                                  mate: conversation.participantName,
                                ),
                              ),
                            );
                          },
                          child: _buildMessageTile(
                              conversation.participantName,
                              conversation.lastMessage,
                              conversation.lastMessageTime.toString(),
                              context),
                        );
                      },
                    );
                  } else if (state is ConversationsError) {
                    return Center(
                      child: Text(state.message),
                    );
                  }
                  return Center(
                    child: Text("No conversation found"),
                  );
                },
              ),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ContactsPage(),
            ),
          );
        },
        backgroundColor: DefaultColors.buttonColor,
        child: Icon(Icons.contacts),
      ),
    );
  }

  Widget _buildMessageTile(
      String name, String message, String time, BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 15),
      leading: const CircleAvatar(
        radius: 30,
        backgroundImage: NetworkImage(
          "https://cellphones.com.vn/sforum/wp-content/uploads/2024/02/avatar-anh-meo-cute-5.jpg",
        ),
      ),
      title: Text(
        name,
        style: const TextStyle(
          color: DefaultColors.whiteText,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        message,
        style: const TextStyle(
          color: Colors.grey,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      trailing: Text(
        time,
        style: const TextStyle(
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _buildRecentContact(String name, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage(
              "https://cellphones.com.vn/sforum/wp-content/uploads/2024/02/avatar-anh-meo-cute-5.jpg",
            ),
          ),
          const SizedBox(height: 5),
          Text(
            name,
            style: Theme.of(context).textTheme.bodyMedium,
          )
        ],
      ),
    );
  }
}
