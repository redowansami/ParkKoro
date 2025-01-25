// lib/controllers/admin_controller.dart
import 'package:http/http.dart' as http;
import 'dart:convert';

class AdminController {
  Future<List<dynamic>> fetchUnverifiedSpots() async {
    try {
      final response = await http.get(
        Uri.parse('http://127.0.0.1:5000/unverified_parking_spots'),
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to fetch unverified spots');
      }
    } catch (e) {
      throw Exception('Failed to fetch data: $e');
    }
  }

  Future<void> reviewSpot(int id, bool approve) async {
    try {
      final response = await http.post(
        Uri.parse('http://127.0.0.1:5000/review_parking_spot/$id'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'action': approve ? 'approve' : 'reject'}),
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to complete action: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to complete action: $e');
    }
  }
}