import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:real_chat/core/socket_service.dart';
import 'package:real_chat/features/conversation/domain/usecases/fetch_conversation_use_case.dart';
import 'package:real_chat/features/conversation/presentation/bloc/conversations_event.dart';
import 'package:real_chat/features/conversation/presentation/bloc/conversations_state.dart';

class ConversationsBloc extends Bloc<ConversationEvent, ConversationsState> {
  final FetchConversationUseCase fetchConversationsUseCase;
  final SocketService _socketService = SocketService();

  ConversationsBloc({required this.fetchConversationsUseCase})
      : super(ConversationsInitial()) {
    on<FetchConversations>(_onFetchConversations);
    _initializeSocketListener();
  }

  _initializeSocketListener() {
    try {
      _socketService.socket.on("conversationUpdated", _onConversationUpdated);
    } catch (e) {
      print("Error initializing socket listeners: $e");
    }
  }

  Future<void> _onFetchConversations(
      FetchConversations event, Emitter<ConversationsState> emit) async {
    emit(ConversationsLoading());
    try {
      final conversations = await fetchConversationsUseCase();
      emit(ConversationsLoaded(conversations));
    } catch (e) {
      emit(ConversationsError("Failed to load conversation"));
    }
  }

  void _onConversationUpdated(data) {
    add(FetchConversations());
  }
}
