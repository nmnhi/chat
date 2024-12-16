import "dart:convert";

import "package:flutter_secure_storage/flutter_secure_storage.dart";
import "package:http/http.dart" as http;
import "package:real_chat/features/contacts/data/models/contacts_model.dart";

class ContactsRemoteDateSource {
  final String baseUrl = 'http://localhost:6000';
  // final String baseUrl = 'http://10.0.2.2:6000';

  final _storage = FlutterSecureStorage();

  Future<List<ContactsModel>> fetchContacts() async {
    String token = await _storage.read(key: 'token') ?? '';

    final response = await http.get(Uri.parse('$baseUrl/contacts'),
        headers: {'Authorization': 'Bearer $token'});

    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      return data.map((json) => ContactsModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch contacts: ${response.body}');
    }
  }

  Future<void> addContact({required String email}) async {
    String token = await _storage.read(key: 'token') ?? '';

    final response = await http.post(
      Uri.parse('$baseUrl/contacts'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json'
      },
      body: jsonEncode({
        'contactEmail': email,
      }),
    );

    if (response.statusCode == 201) {
      print('Contact added successfully');
    } else {
      print('Failed to add contact');
    }
  }
}
