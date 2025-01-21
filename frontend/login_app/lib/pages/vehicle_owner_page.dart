import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class VehicleOwnerPage extends StatefulWidget {
  final String username;

  const VehicleOwnerPage({super.key, required this.username});

  @override
  _VehicleOwnerPageState createState() => _VehicleOwnerPageState();
}

class _VehicleOwnerPageState extends State<VehicleOwnerPage> {
  List<dynamic> verifiedSpots = [];

  // Fetch verified parking spots from the backend
  Future<void> fetchVerifiedSpots() async {
    try {
      final response = await http.get(
        Uri.parse('http://127.0.0.1:5000/verified_parking_spots'),
      );
      if (response.statusCode == 200) {
        setState(() {
          verifiedSpots = jsonDecode(response.body);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load parking spots')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  // Display the list of parking spots
  void _navigateToVerifiedSpots() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(title: Text('Verified Parking Spots')),
          body: ListView.builder(
            itemCount: verifiedSpots.length,
            itemBuilder: (context, index) {
              final spot = verifiedSpots[index];
              return Card(
                child: ListTile(
                  title: Text('Spot ID: ${spot['spot_id']}'),
                  subtitle: Text(
                    'Address: ${spot['address']}\n'
                    'Pricing: \$${spot['pricing']}\n'
                    'Availability: ${spot['availability_status'] ? 'Available' : 'Not Available'}',
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    fetchVerifiedSpots(); // Fetch the verified parking spots when the page loads
  }

  // Widget to build sections in the page
  Widget _buildSection(BuildContext context,
      {required IconData icon,
      required String title,
      required String description,
      required VoidCallback onTap}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: ListTile(
        leading: Icon(icon, size: 40),
        title: Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        subtitle: Text(description),
        trailing: Icon(Icons.arrow_forward),
        onTap: onTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vehicle Owner Dashboard'),
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

            // Search Parking Spots Section
            _buildSection(
              context,
              icon: Icons.search,
              title: 'Search Parking Spots',
              description: 'Find nearby available parking spots.',
              onTap: _navigateToVerifiedSpots, // Navigate to the verified spots page
            ),

            // Reserve Spot Section
            _buildSection(
              context,
              icon: Icons.bookmark_add,
              title: 'Reserve Spot',
              description: 'Book a parking spot for your vehicle.',
              onTap: () {
                // Implement reserve spot functionality
              },
            ),

            // Cancel Booking Section
            _buildSection(
              context,
              icon: Icons.cancel,
              title: 'Cancel Booking',
              description: 'Cancel your active bookings.',
              onTap: () {
                // Implement cancel booking functionality
              },
            ),

            // Payment Section
            _buildSection(
              context,
              icon: Icons.payment,
              title: 'Payment',
              description: 'Make payments for parking spots.',
              onTap: () {
                // Implement payment functionality
              },
            ),

            // Review Parking Spot Section
            _buildSection(
              context,
              icon: Icons.rate_review,
              title: 'Review Parking Spot',
              description: 'Leave feedback about a parking spot.',
              onTap: () {
                // Implement review functionality
              },
            ),

            // Navigation Section
            _buildSection(
              context,
              icon: Icons.navigation,
              title: 'Get Navigation',
              description: 'Access navigation to your booked spot.',
              onTap: () {
                // Implement navigation functionality
              },
            ),

            // Booking History Section
            _buildSection(
              context,
              icon: Icons.history,
              title: 'View Booking History',
              description: 'See your past bookings.',
              onTap: () {
                // Implement view booking history functionality
              },
            ),
          ],
        ),
      ),
    );
  }
}