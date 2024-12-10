import 'package:real_chat/features/chat/domain/repositories/message_repository.dart';

class FetchMessageUseCase {
  final MessageRepository messageRepository;

  FetchMessageUseCase({required this.messageRepository});

  call(String conversationId) async {
    return await messageRepository.fetchMessages(conversationId);
  }
}
