import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SpaceOwnerPage extends StatefulWidget {
  final String username;

  const SpaceOwnerPage({super.key, required this.username});

  @override
  _SpaceOwnerPageState createState() => _SpaceOwnerPageState();
}

class _SpaceOwnerPageState extends State<SpaceOwnerPage> {
  final TextEditingController _spotIdController = TextEditingController();
  final TextEditingController _gpsController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _pricingController = TextEditingController();
  bool _evCharging = false;
  bool _surveillance = false;

  Future<void> submitParkingSpot() async {
    try {
      final response = await http.post(
        Uri.parse('http://127.0.0.1:5000/add_parking_spot'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'spot_id': _spotIdController.text,
          'gps_coordinates': _gpsController.text,
          'address': _addressController.text,
          'pricing': double.parse(_pricingController.text),
          'availability_status': true,
          'ev_charging_availability': _evCharging,
          'surveillance_availability': _surveillance,
        }),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Parking spot submitted for review.')),
        );
        _spotIdController.clear();
        _gpsController.clear();
        _addressController.clear();
        _pricingController.clear();
        setState(() {
          _evCharging = false;
          _surveillance = false;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to submit parking spot.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }
  }

  Widget _buildSection(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: ListTile(
        leading: Icon(icon, size: 40),
        title: Text(
          title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(description),
        trailing: Icon(Icons.arrow_forward),
        onTap: onTap,
      ),
    );
  }

  void _showRegisterSpaceDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Register Parking Space'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _spotIdController,
                  decoration: InputDecoration(labelText: 'Spot ID'),
                ),
                TextField(
                  controller: _gpsController,
                  decoration: InputDecoration(labelText: 'GPS Coordinates'),
                ),
                TextField(
                  controller: _addressController,
                  decoration: InputDecoration(labelText: 'Address'),
                ),
                TextField(
                  controller: _pricingController,
                  decoration: InputDecoration(labelText: 'Pricing'),
                  keyboardType: TextInputType.number,
                ),
                Row(
                  children: [
                    Text('EV Charging'),
                    Switch(
                      value: _evCharging,
                      onChanged: (value) {
                        setState(() {
                          _evCharging = value;
                        });
                      },
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text('Surveillance'),
                    Switch(
                      value: _surveillance,
                      onChanged: (value) {
                        setState(() {
                          _surveillance = value;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                submitParkingSpot();
              },
              child: Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Space Owner Dashboard'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Navigator.pop(context); // Log out functionality
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome, ${widget.username}!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),

            // Register Space Section
            _buildSection(
              context,
              icon: Icons.add_location_alt,
              title: 'Register Space',
              description: 'List a new parking space for customers.',
              onTap: _showRegisterSpaceDialog,
            ),

            // Set Pricing Section
            _buildSection(
              context,
              icon: Icons.price_change,
              title: 'Set Pricing',
              description: 'Set pricing for your parking spaces.',
              onTap: () {
                // Implement set pricing functionality
              },
            ),

            // Set Cancel Policy Section
            _buildSection(
              context,
              icon: Icons.policy,
              title: 'Set Cancel Policy',
              description: 'Define cancellation policies for bookings.',
              onTap: () {
                // Implement set cancel policy functionality
              },
            ),

            // Monitor Earnings Section
            _buildSection(
              context,
              icon: Icons.attach_money,
              title: 'Monitor Earnings',
              description: 'View and track your earnings.',
              onTap: () {
                // Implement monitor earnings functionality
              },
            ),

            // Track Reviews Section
            _buildSection(
              context,
              icon: Icons.reviews,
              title: 'Track Reviews',
              description: 'View and respond to customer reviews.',
              onTap: () {
                // Implement track reviews functionality
              },
            ),
          ],
        ),
      ),
    );
  }
}
