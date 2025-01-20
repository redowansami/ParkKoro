// import 'package:flutter/material.dart';

// class AdminPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Admin Dashboard')),
//       body: Center(child: Text('Welcome, Admin!')),
//     );
//   }
// }

import 'package:flutter/material.dart';

class AdminPage extends StatelessWidget {
  final String username;

  const AdminPage({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard'),
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
              'Welcome, Admin $username!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),

            // Review Request
            _buildSection(
              context,
              icon: Icons.add_circle,
              title: 'View Requests',
              description: 'Approve parking spaces.',
              onTap: () {
                // Implement add parking space functionality
              },
            ),

            // Remove Parking Space Section
            _buildSection(
              context,
              icon: Icons.delete,
              title: 'Remove Parking Space',
              description: 'Delete or suspend non-compliant parking spaces.',
              onTap: () {
                // Implement remove parking space functionality
              },
            ),

            // Handle Complaints Section
            _buildSection(
              context,
              icon: Icons.report_problem,
              title: 'Handle Complaints',
              description: 'View and address user complaints.',
              onTap: () {
                // Implement handle complaints functionality
              },
            ),

            // Add Announcements Section
            _buildSection(
              context,
              icon: Icons.campaign,
              title: 'Add Announcements',
              description: 'Send notifications or announcements.',
              onTap: () {
                // Implement add announcements functionality
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
