import 'package:real_chat/features/conversation/data/datasources/conversations_remote_data_source.dart';
import 'package:real_chat/features/conversation/domain/entities/conversation_entity.dart';
import 'package:real_chat/features/conversation/domain/repositories/conversation_repository.dart';

class ConversationRepositoryImpl implements ConversationRepository {
  final ConversationsRemoteDataSource conversationsRemoteDataSource;

  ConversationRepositoryImpl({required this.conversationsRemoteDataSource});
  @override
  Future<List<ConversationEntity>> fetchConversation() async {
    return await conversationsRemoteDataSource.fetchConversations();
  }

  @override
  Future<String> checkOrCreateConversation({required String contactId}) async {
    return await conversationsRemoteDataSource.checkOrCreateConversation(
        contactId: contactId);
  }
}
