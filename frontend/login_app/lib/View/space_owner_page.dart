import 'package:flutter/material.dart';
import 'package:login_app/View/fetch_earning_screen.dart';
import 'package:login_app/View/login_page.dart';
import 'package:login_app/View/spaceOwner/add_listing_screen.dart';
import 'package:login_app/View/spaceOwner/edit_listing_screen.dart';
import 'package:login_app/View/spaceOwner/edit_profile_screen.dart';
import 'package:login_app/View/spaceOwner/track_review_screen.dart';
import 'package:login_app/View/spaceOwner/surveillance_screen.dart';
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
        backgroundColor: const Color(0xFF1E3A8A),
        title: Row(
          children: [
            Image.asset(
              'assets/logo.png', // Ensure you have this in your assets folder
              height: 32,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 10),
            const Text(
              'Space Owner Dashboard',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
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
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1E3A8A),
              Color(0xFF3B82F6),
            ],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome, ${widget.username}!',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 20),
              _buildSection(
                context,
                icon: Icons.add_location_alt,
                title: 'Register Space',
                description: 'List a new parking space for customers.',
                onTap: () {
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
                      builder: (context) => EditProfileScreen(username: widget.username),
                    ),
                  );
                },
              ),
              _buildSection(
                context,
                icon: Icons.notifications,
                title: 'Notification',
                description: 'View important notifications.',
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
                      builder: (context) => TrackReviewsScreen(ownerId: widget.username),
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FetchEarningsScreen(ownerId: widget.username),
                    ),
                  );
                },
              ),
              _buildSection(
                context,
                icon: Icons.security,
                title: 'Surveillance Settings',
                description: 'Enable or disable surveillance options.',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SurveillanceScreenPage(username: widget.username),
                    ),
                  );
                },
              ),
            ],
          ),
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
      color: Colors.white.withOpacity(0.9),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 3,
      child: ListTile(
        leading: Icon(icon, size: 40, color: const Color(0xFF1E3A8A)),
        title: Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E3A8A)),
        ),
        subtitle: Text(description, style: const TextStyle(color: Colors.black87)),
        trailing: const Icon(Icons.arrow_forward, color: Color(0xFF1E3A8A)),
        onTap: onTap,
      ),
    );
  }
}
