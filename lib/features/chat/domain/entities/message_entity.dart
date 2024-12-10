// ignore_for_file: public_member_api_docs, sort_constructors_first


class MessageEntity {
  final String id;
  final String conversationId;
  final String senderId;
  final String content;
  final String createdAt;

  MessageEntity({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.content,
    required this.createdAt,
  });

}
