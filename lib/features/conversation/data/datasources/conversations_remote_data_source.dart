import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import "package:http/http.dart" as http;
import 'package:real_chat/features/conversation/data/models/conversation_model.dart';

class ConversationsRemoteDataSource {
  final String baseUrl = "http://localhost:6000";
  // final String baseUrl = "http://10.0.2.2:6000";
  final _storage = FlutterSecureStorage();

  Future<List<ConversationModel>> fetchConversations() async {
    String token = await _storage.read(key: 'token') ?? '';

    final response = await http.get(
      Uri.parse('$baseUrl/conversations'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      return data.map((json) => ConversationModel.fromJson(json)).toList();
    } else {
      final responseBody = jsonDecode(response.body);
      final errorMessage = responseBody['error'] ?? "Unknown error occurred";
      throw Exception('$errorMessage');
    }
  }

  Future<String> checkOrCreateConversation({required String contactId}) async {
    String token = await _storage.read(key: 'token') ?? '';

    final response = await http.post(
      Uri.parse('$baseUrl/conversations/check-or-create'),
      body: jsonEncode({
        'contactId': contactId,
      }),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      return responseBody['conversationId'] ?? '';
    } else {
      final responseBody = jsonDecode(response.body);
      final errorMessage = responseBody['error'] ?? "Unknown error occurred";
      throw Exception('$errorMessage');
    }
  }
}
