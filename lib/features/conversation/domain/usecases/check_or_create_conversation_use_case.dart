import 'package:real_chat/features/conversation/domain/repositories/conversation_repository.dart';

class CheckOrCreateConversationUseCase {
  final ConversationRepository conversationRepository;

  CheckOrCreateConversationUseCase({required this.conversationRepository});

  Future<String> call({required String contactId}) async {
    return conversationRepository.checkOrCreateConversation(
        contactId: contactId);
  }
}
