import 'package:flutter/material.dart';
import 'package:login_app/View/login_page.dart';
import 'package:login_app/View/spaceOwner/add_listing_screen.dart';
import 'package:login_app/View/spaceOwner/edit_listing_screen.dart';
import 'package:login_app/View/spaceOwner/edit_profile_screen.dart';
import 'package:login_app/View/spaceOwner/track_review_screen.dart';
import 'package:login_app/View/view_notification_screen.dart';

class SpaceOwnerPage extends StatefulWidget {
  final String username;

  const SpaceOwnerPage({super.key, required this.username});

  @override
  _SpaceOwnerPageState createState() => _SpaceOwnerPageState();
}

class _SpaceOwnerPageState extends State<SpaceOwnerPage> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Space Owner Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
                (route) => false,
              );
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
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            _buildSection(
              context,
              icon: Icons.add_location_alt,
              title: 'Register Space',
              description: 'List a new parking space for customers.',
              onTap: () {
                // Navigate to AddListingScreen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddListingScreen(username: widget.username),
                  ),
                );
              },
            ),
            _buildSection(
              context,
              icon: Icons.edit,
              title: 'Edit Listing',
              description: 'Edit or remove your parking spots.',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditListingScreen(username: widget.username),
                  ),
                );
              },
            ),
            _buildSection(
              context,
              icon: Icons.person,
              title: 'Edit Profile',
              description: 'Update your personal details.',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditProfileScreen(username: widget.username),  // Pass the username to the EditProfileScreen
                  ),
                );
              },
            ),
            _buildSection(
              context,
              icon: Icons.notifications,
              title: 'Notification',
              description: 'Update your personal details.',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ViewNotificationScreen()),
                );
              },
            ),
            _buildSection(
              context,
              icon: Icons.analytics,
              title: 'View Analytics',
              description: 'View performance reports and analytics.',
              onTap: () {
                // Add logic for viewing analytics
              },
            ),
            _buildSection(
              context,
              icon: Icons.rate_review,
              title: 'Track Reviews',
              description: 'Monitor and respond to user reviews.',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TrackReviewsScreen(ownerId: widget.username), // Pass the owner ID
                  ),
                );
              },
            ),
            _buildSection(
              context,
              icon: Icons.monetization_on,
              title: 'Monitor Earnings',
              description: 'Track your earnings and occupancy.',
              onTap: () {
                // Add logic for monitoring earnings
              },
            ),
            _buildSection(
              context,
              icon: Icons.security,
              title: 'Surveillance Settings',
              description: 'Enable or disable surveillance options.',
              onTap: () {
                // Add logic for surveillance settings
              },
            ),
          ],
        ),
      ),
    );
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
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(description),
        trailing: const Icon(Icons.arrow_forward),
        onTap: onTap,
      ),
    );
  }
}
