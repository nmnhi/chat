import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import "package:http/http.dart" as http;
import 'package:real_chat/features/chat/data/models/message_model.dart';

class MessageRemoteDataSource {
  final String baseUrl = "http://localhost:6000";
  // final String baseUrl = "http://10.0.2.2:6000";
  final _storage = FlutterSecureStorage();

  Future<List<MessageModel>> fetchMessages(String conversationId) async {
    String token = await _storage.read(key: "token") ?? '';

    final response = await http.get(
        Uri.parse("$baseUrl/messages/$conversationId"),
        headers: {"Authorization": "bearer $token"});

    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);

      return data.map((json) => MessageModel.fromJson(json)).toList();
    } else {
      throw Exception("Failed to fetch messages");
    }
  }
}
