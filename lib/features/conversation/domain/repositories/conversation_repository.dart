import 'package:real_chat/features/conversation/domain/entities/conversation_entity.dart';

abstract class ConversationRepository {
  Future<List<ConversationEntity>> fetchConversation();
  Future<String> checkOrCreateConversation({required String contactId});
}
