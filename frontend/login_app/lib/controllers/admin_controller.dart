import 'package:http/http.dart' as http;
import 'dart:convert';

class AdminController {
  Future<List<dynamic>> fetchUnverifiedSpots() async {
    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:5000/unverified_parking_spots'),
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

  Future<void> reviewSpot(int spotId, String action) async {
    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:5000/review_parking_spot/$spotId'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'action': action}), // Send "accept" or "delete"
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to complete action: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to complete action: $e');
    }
  }

   // Fetch all users
  Future<List<dynamic>> fetchAllUsers() async {
    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:5000/admin/users'),
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to fetch users');
      }
    } catch (e) {
      throw Exception('Error fetching users: $e');
    }
  }

  // Delete a user
  Future<void> deleteUser(int userId) async {
    try {
      final response = await http.delete(
        Uri.parse('http://10.0.2.2:5000/admin/users/$userId'),
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to delete user');
      }
    } catch (e) {
      throw Exception('Error deleting user: $e');
    }
  }
}