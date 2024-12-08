import 'dart:convert';

import "package:http/http.dart" as http;
import 'package:real_chat/features/auth/data/models/user_model.dart';

class AuthRemoteDataSource {
  final String baseUrl = 'http://localhost:6000/auth';

  Future<UserModel> login(
      {required String email, required String password}) async {
    final response = await http.post(Uri.parse("$baseUrl/login"),
        body: jsonEncode({"email": email, "password": password}),
        headers: {'Content-Type': 'application/json'});

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      if (responseBody != null && responseBody.containsKey("user")) {
        return UserModel.fromJson(responseBody["user"]);
      } else {
        throw Exception("User not found in response.");
      }
    } else {
      final responseBody = jsonDecode(response.body);
      // Extract the error message from the server's response
      final errorMessage = responseBody["error"] ?? "Unknown error occurred";
      throw Exception("$errorMessage");
    }
  }

  Future<UserModel> register(
      {required String username,
      required String email,
      required String password}) async {
    final response = await http.post(Uri.parse("$baseUrl/register"),
        body: jsonEncode(
            {"username": username, "email": email, "password": password}),
        headers: {'Content-Type': 'application/json'});

    if (response.statusCode == 201) {
      final responseBody = jsonDecode(response.body);
      if (responseBody != null && responseBody.containsKey("user")) {
        return UserModel.fromJson(responseBody["user"]);
      } else {
        throw Exception("User not found in response.");
      }
    } else {
      final responseBody = jsonDecode(response.body);
      // Extract the error message from the server's response
      final errorMessage = responseBody["error"] ?? "Unknown error occurred";
      throw Exception("$errorMessage");
    }
  }
}
