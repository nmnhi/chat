import 'package:real_chat/features/chat/domain/entities/message_entity.dart';

class MessageModel extends MessageEntity {
  // ignore: use_super_parameters
  MessageModel({
    required id,
    required conversationId,
    required senderId,
    required content,
    required createdAt,
  }) : super(
          id: id,
          conversationId: conversationId,
          senderId: senderId,
          content: content,
          createdAt: createdAt,
        );

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'] ?? '',
      conversationId: json['conversation_id'] ?? '',
      senderId: json['sender_id'] ?? '',
      content: json['content'] ?? '',
      createdAt: json['created_at'] ?? '',
    );
  }
}
