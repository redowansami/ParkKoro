// lib/controllers/parking_spot_controller.dart
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/parking_spot.dart';

class ParkingSpotController {
  Future<List<ParkingSpot>> fetchVerifiedSpots() async {
    final response = await http.get(Uri.parse('http://127.0.0.1:5000/verified_parking_spots'));
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => ParkingSpot.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load parking spots');
    }
  }

  Future<void> submitParkingSpot(ParkingSpot spot) async {
    final response = await http.post(
      Uri.parse('http://127.0.0.1:5000/add_parking_spot'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(spot.toJson()),
    );
    if (response.statusCode != 201) {
      throw Exception('Failed to submit parking spot');
    }
  }
}