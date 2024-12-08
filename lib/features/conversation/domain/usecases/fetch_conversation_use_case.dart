import 'package:real_chat/features/conversation/domain/entities/conversation_entity.dart';
import 'package:real_chat/features/conversation/domain/repositories/conversation_repository.dart';

class FetchConversationUseCase {
  final ConversationRepository conversationsRepository;
  FetchConversationUseCase({required this.conversationsRepository});
  Future<List<ConversationEntity>> call() async {
    return conversationsRepository.fetchConversation();
  }
}
