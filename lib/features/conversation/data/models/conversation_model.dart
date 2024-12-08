import 'package:real_chat/features/conversation/domain/entities/conversation_entity.dart';

class ConversationModel extends ConversationEntity {
  // ignore: use_super_parameters
  ConversationModel({
    required id,
    required participantName,
    required lastMessage,
    required lastMessageTime,
  }) : super(
          id: id,
          participantName: participantName,
          lastMessage: lastMessage,
          lastMessageTime: lastMessageTime,
        );

  factory ConversationModel.fromJson(Map<String, dynamic> json) {
    return ConversationModel(
      id: json['conversation_id'] ?? '',
      participantName: json['participant_name'] ?? '',
      lastMessage: json['last_message'] ?? '',
      lastMessageTime: _parseDateTime(json['last_message_time']),
    );
  }

  /// Helper function to parse the date-time safely
  static DateTime _parseDateTime(dynamic dateTimeString) {
    if (dateTimeString == null) {
      // Return a default date-time if null
      return DateTime.now();
    }

    try {
      return DateTime.parse(dateTimeString);
    } catch (e) {
      // Return a fallback date-time if parsing fails
      return DateTime.now();
    }
  }
}
