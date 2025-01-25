// lib/controllers/login_controller.dart
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginController {
  Future<Map<String, dynamic>> loginUser(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('http://127.0.0.1:5000/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username, 'password': password}),
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Invalid credentials');
      }
    } catch (e) {
      throw Exception('An error occurred: $e');
    }
  }
}