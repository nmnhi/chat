import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:real_chat/core/socket_service.dart';
import 'package:real_chat/features/chat/domain/entities/message_entity.dart';
import 'package:real_chat/features/chat/domain/usecases/fetch_message_use_case.dart';
import 'package:real_chat/features/chat/presentation/bloc/chat_event.dart';
import 'package:real_chat/features/chat/presentation/bloc/chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final FetchMessageUseCase fetchMessageUseCase;
  final SocketService _socketService = SocketService();
  final List<MessageEntity> _messages = [];
  final _storage = FlutterSecureStorage();

  ChatBloc({required this.fetchMessageUseCase}) : super(ChatLoadingState()) {
    on<LoadMessagesEvent>(_onLoadingMessage);
    on<SendMessageEvent>(_onSendMessage);
    on<ReceiveMessageEvent>(_onReceiveMessage);
  }

  Future<void> _onLoadingMessage(
      LoadMessagesEvent event, Emitter<ChatState> emit) async {
    emit(ChatLoadingState());
    try {
      final messages = await fetchMessageUseCase(event.conversationId);
      _messages.clear();
      _messages.addAll(
        messages.map<MessageEntity>(
          (messageModel) => MessageEntity(
            id: messageModel.id,
            conversationId: messageModel.conversationId,
            senderId: messageModel.senderId,
            content: messageModel.content,
            createdAt: messageModel.createdAt,
          ),
        ),
      );

      emit(ChatLoadedState(List.from(_messages)));

      _socketService.socket.emit("joinConversation", event.conversationId);
      _socketService.socket.on(
        "newMessage",
        (data) => {
          print("Step 1 - receive: $data"),
          add(ReceiveMessageEvent(data)),
        },
      );
    } catch (e) {
      print("Issue here $e");
      emit(ChatErrorState('Failed to load messages'));
    }
  }

  Future<void> _onSendMessage(
      SendMessageEvent event, Emitter<ChatState> emit) async {
    String userId = await _storage.read(key: "userId") ?? '';

    final newMessage = {
      "conversationId": event.conversationId,
      "senderId": userId,
      "content": event.content
    };
    _socketService.socket.emit("sendMessage", newMessage);
  }

  Future<void> _onReceiveMessage(
      ReceiveMessageEvent event, Emitter<ChatState> emit) async {
    print("Step 2 - receive message called");

    final message = MessageEntity(
      id: event.message['id'] ?? '',
      conversationId: event.message['conversation_id'] ?? '',
      senderId: event.message['sender_id'] ?? '',
      content: event.message['content'] ?? '',
      createdAt: event.message['created_at'] ?? '',
    );
    _messages.add(message);
    emit(ChatLoadedState(List.from(_messages)));
  }
}
