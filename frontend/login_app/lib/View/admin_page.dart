import 'package:flutter/material.dart';
import 'package:login_app/View/admin/manage_listing_screen.dart';
import 'package:login_app/View/admin/manage_users_screen.dart';
import 'package:login_app/View/admin/review_requests_screen.dart';
import 'package:login_app/View/admin/send_notification_screen.dart';
import 'login_page.dart';

class AdminPage extends StatefulWidget {
  final String username;

  const AdminPage({super.key, required this.username});

  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Admin Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // Logout logic
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
                (route) => false,
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2, // Two sections per row
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            _buildDashboardCard(
              context,
              icon: Icons.list,
              title: 'View Requests',
              subtitle: 'Approve/reject parking spaces',
              navigateTo: const ReviewRequestsScreen(),
            ),
            _buildDashboardCard(
              context,
              icon: Icons.people,
              title: 'Manage Users',
              subtitle: 'View and remove users',
              navigateTo: const ManageUsersScreen(),
            ),
            _buildDashboardCard(
              context,
              icon: Icons.local_parking,
              title: 'Manage Listings',
              subtitle: 'View and remove listings',
              navigateTo: const ManageListingsScreen(),
            ),
            _buildDashboardCard(
              context,
              icon: Icons.star_rate,
              title: 'Manage Reviews',
              subtitle: 'View and remove reviews',
              navigateTo: const ManageReviewsScreen(),
              
            ),
            _buildDashboardCard(
              context,
              icon: Icons.payment,
              title: 'Transactions',
              subtitle: 'View payments & refunds',
              navigateTo: const ManageTransactionsScreen(),
              
            ),
            _buildDashboardCard(
              context,
              icon: Icons.report,
              title: 'Notifications',
              subtitle: 'Send alerts',
              navigateTo: const SendNotificationScreen(),
              
            ),
            _buildDashboardCard(
              context,
              icon: Icons.analytics,
              title: 'Analytics',
              subtitle: 'View booking & revenue stats',
              navigateTo: const ManageAnalyticsScreen(),
              
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Widget navigateTo,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => navigateTo),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: Colors.blueAccent),
              const SizedBox(height: 10),
              Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 5),
              Text(subtitle, textAlign: TextAlign.center, style: const TextStyle(fontSize: 14, color: Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }
}

// Dummy Screens for Navigation
class ManageReviewsScreen extends StatelessWidget {
  const ManageReviewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manage Reviews')),
      body: Center(child: Text('Review management features will be added here.')),
    );
  }
}

class ManageTransactionsScreen extends StatelessWidget {
  const ManageTransactionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manage Transactions')),
      body: Center(child: Text('Transaction features will be added here.')),
    );
  }
}

class ManageNotificationsScreen extends StatelessWidget {
  const ManageNotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manage Notifications')),
      body: Center(child: Text('Notification features will be added here.')),
    );
  }
}

class ManageAnalyticsScreen extends StatelessWidget {
  const ManageAnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manage Analytics')),
      body: Center(child: Text('Analytics features will be added here.')),
    );
  }
}
