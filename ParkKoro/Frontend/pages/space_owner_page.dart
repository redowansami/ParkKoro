import 'package:flutter/material.dart';

class SpaceOwnerPage extends StatelessWidget {
  final String username;

  const SpaceOwnerPage({super.key, required this.username});

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
              'Welcome, $username!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),

            // // Register Space Section
            // _buildSection(
            //   context,
            //   icon: Icons.add_location_alt,
            //   title: 'Register Space',
            //   description: 'List a new parking space for customers.',
            //   onTap: () {
            //     // Implement register space functionality
            //   },
            // ),

            // Register Space Section
            _buildSection(
              context,
              icon: Icons.add_location_alt,
              title: 'Register Space',
              description: 'List a new parking space for customers.',
              onTap: () {
                //add functionality
              },
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
