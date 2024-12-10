import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:real_chat/core/theme.dart';
import 'package:real_chat/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:real_chat/features/chat/presentation/bloc/chat_event.dart';
import 'package:real_chat/features/chat/presentation/bloc/chat_state.dart';

class ChatPage extends StatefulWidget {
  final String conversationId;
  final String mate;
  const ChatPage({super.key, required this.conversationId, required this.mate});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();

  final _storage = FlutterSecureStorage();

  String userId = '';

  @override
  void initState() {
    super.initState();
    BlocProvider.of<ChatBloc>(context)
        .add(LoadMessagesEvent(widget.conversationId));
    fetchUserId();
  }

  fetchUserId() async {
    userId = await _storage.read(key: "userId") ?? '';
    setState(() {
      userId = userId;
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final content = _messageController.text.trim();
    if (content.isEmpty) return;
    BlocProvider.of<ChatBloc>(context)
        .add(SendMessageEvent(widget.conversationId, content));

    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          children: [
            const CircleAvatar(
              backgroundImage: NetworkImage(
                "https://cellphones.com.vn/sforum/wp-content/uploads/2024/02/avatar-anh-meo-cute-5.jpg",
              ),
            ),
            const SizedBox(width: 10),
            Text(
              widget.mate,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
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
        children: [
          Expanded(
            child: BlocBuilder<ChatBloc, ChatState>(
              builder: (context, state) {
                if (state is ChatLoadingState) {
                  return Center(child: CircularProgressIndicator());
                } else if (state is ChatLoadedState) {
                  return ListView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: state.messages.length,
                    itemBuilder: (context, index) {
                      final message = state.messages[index];
                      final isSentMessage = message.senderId == userId;
                      if (isSentMessage) {
                        return _buildSendMessage(context, message.content);
                      } else {
                        return _buildReceivedMessage(context, message.content);
                      }
                    },
                  );
                } else if (state is ChatErrorState) {
                  return Center(
                    child: Text(state.message),
                  );
                }
                return Center(
                  child: Text("No message found"),
                );
              },
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildReceivedMessage(BuildContext context, String message) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(right: 30, top: 5, bottom: 5),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: DefaultColors.receiverMessage,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Text(
          message,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    );
  }

  Widget _buildSendMessage(BuildContext context, String message) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.only(right: 30, top: 5, bottom: 5),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: DefaultColors.senderMessage,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Text(
          message,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      decoration: BoxDecoration(
        color: DefaultColors.sendMessageInput,
        borderRadius: BorderRadius.circular(25),
      ),
      margin: const EdgeInsets.all(25),
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        children: [
          GestureDetector(
            child: const Icon(
              Icons.camera_alt,
              color: Colors.grey,
            ),
            onTap: () {},
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: const InputDecoration(
                  hintText: "Message",
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none),
              style: const TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: _sendMessage,
            child: const Icon(
              Icons.send,
              color: Colors.grey,
            ),
          )
        ],
      ),
    );
  }
}
