import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = "https://reqres.in/api";
  final Map<String, String> headers = {"x-api-key": "reqres-free-v1"};

  Future<Map<String, dynamic>> getUsers(int page) async {
    final response = await http.get(
      Uri.parse('$baseUrl/users?page=$page'),
      // headers: headers,
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception("Failed to load users");
    }
  }

  Future<Map<String, dynamic>> getUserById(int userId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/users/$userId'),
      // headers: headers,
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception("Failed to load user details");
    }
  }
}
