import 'package:real_chat/features/chat/data/datasources/message_remote_data_source.dart';
import 'package:real_chat/features/chat/domain/entities/message_entity.dart';
import 'package:real_chat/features/chat/domain/repositories/message_repository.dart';

class MessageRepositoryImpl implements MessageRepository {
  final MessageRemoteDataSource messageRemoteDataSource;

  MessageRepositoryImpl({required this.messageRemoteDataSource});

  @override
  Future<List<MessageEntity>> fetchMessages(String conversationId) {
    return messageRemoteDataSource.fetchMessages(conversationId);
  }

  @override
  Future<void> sendMessage(MessageEntity message) {
    // TODO: implement sendMessage
    throw UnimplementedError();
  }
}
