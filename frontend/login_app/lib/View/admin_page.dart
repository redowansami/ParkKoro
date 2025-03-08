import 'package:flutter/material.dart';
import 'package:login_app/View/admin/manage_listing_screen.dart';
import 'package:login_app/View/admin/manage_users_screen.dart';
import 'package:login_app/View/admin/review_requests_screen.dart';
import 'package:login_app/View/admin/send_notification_screen.dart';
import 'package:login_app/View/admin/view_review_screen.dart';
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
        backgroundColor: const Color(0xFF1E3A8A),
        title: Row(
          children: [
            // Only the logo here
            Image.asset(
              'assets/logo.png', // Add your logo here
              height: 30, // Adjust the logo size
              width: 30, // Adjust the logo size
            ),
            const SizedBox(width: 10),
            const Text(
              'Admin Dashboard',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w400,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
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
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(24, 20, 24, 12),
                child: Text(
                  'ParkKoro Admin Management Console',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Container(
                  height: 2,
                  width: 100,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(1),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
                child: Text(
                  'Select an option to manage your parking system',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // Two sections per row
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: 7, // Number of dashboard cards
                    itemBuilder: (context, index) {
                      final items = [
                        {
                          'icon': Icons.list,
                          'title': 'View Requests',
                          'subtitle': 'Approve/reject parking spaces',
                          'navigateTo': const ReviewRequestsScreen(),
                        },
                        {
                          'icon': Icons.people,
                          'title': 'Manage Users',
                          'subtitle': 'View and remove users',
                          'navigateTo': const ManageUsersScreen(),
                        },
                        {
                          'icon': Icons.local_parking,
                          'title': 'Manage Listings',
                          'subtitle': 'View and remove listings',
                          'navigateTo': const ManageListingsScreen(),
                        },
                        {
                          'icon': Icons.star_rate,
                          'title': 'Manage Reviews',
                          'subtitle': 'View and remove reviews',
                          'navigateTo': ViewReviewsScreen(),
                        },
                        {
                          'icon': Icons.payment,
                          'title': 'Transactions',
                          'subtitle': 'View payments & refunds',
                          'navigateTo': const ManageTransactionsScreen(),
                        },
                        {
                          'icon': Icons.notifications_active,
                          'title': 'Notifications',
                          'subtitle': 'Send alerts',
                          'navigateTo': const SendNotificationScreen(),
                        },
                        {
                          'icon': Icons.analytics,
                          'title': 'Analytics',
                          'subtitle': 'View booking & revenue stats',
                          'navigateTo': const ManageAnalyticsScreen(),
                        },
                      ];

                      return _buildDashboardCard(
                        context,
                        icon: items[index]['icon'] as IconData,
                        title: items[index]['title'] as String,
                        subtitle: items[index]['subtitle'] as String,
                        navigateTo: items[index]['navigateTo'] as Widget,
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: Colors.white,
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
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E40AF).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  size: 36,
                  color: const Color(0xFF1E40AF),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1E3A8A),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Dummy Screens for Navigation
class ManageTransactionsScreen extends StatelessWidget {
  const ManageTransactionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E3A8A),
        title: const Text(
          'Manage Transactions',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Center(
        child: Text('Transaction features will be added here.'),
      ),
    );
  }
}

class ManageNotificationsScreen extends StatelessWidget {
  const ManageNotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E3A8A),
        title: const Text(
          'Manage Notifications',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Center(
        child: Text('Notification features will be added here.'),
      ),
    );
  }
}

class ManageAnalyticsScreen extends StatelessWidget {
  const ManageAnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E3A8A),
        title: const Text(
          'Manage Analytics',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Center(
        child: Text('Analytics features will be added here.'),
      ),
    );
  }
}
