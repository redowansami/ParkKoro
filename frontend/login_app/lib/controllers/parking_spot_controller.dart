import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/parking_spot.dart';

class ParkingSpotController {
  Future<List<ParkingSpot>> fetchVerifiedSpots() async {
    final response = await http.get(Uri.parse('http://10.0.2.2:5000/verified_parking_spots'));
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => ParkingSpot.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load parking spots');
    }
  }

  Future<void> submitParkingSpot(ParkingSpot spot) async {
    final payload = spot.toJson();
    print('Sending payload: $payload'); // Debugging
    final response = await http.post(
      Uri.parse('http://10.0.2.2:5000/add_parking_spot'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(payload),
    );
    if (response.statusCode != 201) {
      print('Failed with status code: ${response.statusCode}'); // Debugging
      print('Response body: ${response.body}'); // Debugging
      throw Exception('Failed to submit parking spot');
    }
  }

  Future<List<ParkingSpot>> fetchUnverifiedSpots() async {
    final response = await http.get(Uri.parse('http://10.0.2.2:5000/unverified_parking_spots'));
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => ParkingSpot.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load unverified parking spots');
    }
  }

  Future<void> reviewParkingSpot(int spotId, String action) async {
    if (spotId == 0) {
      throw Exception('Spot ID cannot be null or empty');
    }

    final response = await http.post(
      Uri.parse('http://10.0.2.2:5000/review_parking_spot/$spotId'),  // Use spotId as integer
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'action': action}),
    );

    if (response.statusCode == 200) {
      print('Action completed successfully: ${response.body}');
    } else {
      throw Exception('Failed to complete action: ${response.body}');
    }
  }

  // Delete a parking spot
  Future<void> deleteParkingSpot(int spotId) async {
    final response = await http.delete(
      Uri.parse('http://10.0.2.2:5000/admin/parking_spots/$spotId'),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to delete parking spot');
    }
  }
}
