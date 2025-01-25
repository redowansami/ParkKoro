// lib/controllers/register_controller.dart
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/register_model.dart'; // Import the RegisterModel class

class RegisterController {
  Future<Map<String, dynamic>> fetchVehicleOwnerData(String nid) async {
    try {
      final response = await http.get(
        Uri.parse('http://127.0.0.1:5000/brta?nid=$nid'),
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to fetch data: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('An error occurred: $e');
    }
  }

  Future<void> registerUser(RegisterModel model) async {
    try {
      final response = await http.post(
        Uri.parse('http://127.0.0.1:5000/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': model.username,
          'password': model.password,
          'user_type': model.userType,
          'nid': model.userType == 'VehicleOwner' ? model.nid : null,
          'email': model.email,
          'phone': model.phone,
          'car_type': model.userType == 'VehicleOwner' ? model.carType : null,
          'license_plate_number': model.userType == 'VehicleOwner' ? model.licensePlate : null,
          'driving_license_number': model.userType == 'VehicleOwner' ? model.drivingLicense : null,
        }),
      );
      if (response.statusCode != 201) {
        throw Exception('Registration failed: ${response.body}');
      }
    } catch (e) {
      throw Exception('An error occurred: $e');
    }
  }
}