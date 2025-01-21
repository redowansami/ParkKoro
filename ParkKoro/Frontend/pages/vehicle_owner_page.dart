// import 'package:flutter/material.dart';

// class VehicleOwnerPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Vehicle Owner Dashboard')),
//       body: Center(child: Text('Welcome, Vehicle Owner!')),
//     );
//   }
// }

import 'package:flutter/material.dart';

class VehicleOwnerPage extends StatelessWidget {
  final String username;

  const VehicleOwnerPage({super.key, required this.username});

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
              'Welcome, $username!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),

            // Search Parking Spots Section
            _buildSection(
              context,
              icon: Icons.search,
              title: 'Search Parking Spots',
              description: 'Find nearby available parking spots.',
              onTap: () {
                // Implement search functionality
              },
            ),

            // View Details Section
            _buildSection(
              context,
              icon: Icons.info_outline,
              title: 'View Details',
              description: 'See details of parking spots.',
              onTap: () {
                // Implement view details functionality
              },
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
}
