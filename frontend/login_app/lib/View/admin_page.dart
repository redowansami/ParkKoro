// import 'package:flutter/material.dart';
// import '../controllers/admin_controller.dart';
// import '../models/admin_model.dart';
// import 'login_page.dart';

// class AdminPage extends StatefulWidget {
//   final String username;

//   const AdminPage({super.key, required this.username});

//   @override
//   _AdminPageState createState() => _AdminPageState();
// }

// class _AdminPageState extends State<AdminPage> {
//   final AdminController _controller = AdminController();
//   final AdminModel _model = AdminModel(username: '');

//   @override
//   void initState() {
//     super.initState();
//     _model.username = widget.username;
//     _fetchUnverifiedSpots();
//   }

//   Future<void> _fetchUnverifiedSpots() async {
//     try {
//       final spots = await _controller.fetchUnverifiedSpots();
//       setState(() {
//         _model.updateUnverifiedSpots(spots);
//       });
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to fetch data: $e')),
//       );
//     }
//   }

//   Future<void> _reviewSpot(String spotId, String action) async {
//     try {
//       await _controller.reviewSpot(spotId, action); // Send "accept" or "delete"
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Action completed successfully.')),
//       );
//       _fetchUnverifiedSpots(); // Refresh the list
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to complete action: $e')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         elevation: 0,
//         title: const Text('Admin Dashboard'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.logout),
//             onPressed: () {
//               // Replace the entire navigation stack with login page
//               Navigator.pushAndRemoveUntil(
//                 context,
//                 MaterialPageRoute(builder: (context) => const LoginPage()),
//                 (route) => false, // This will remove all routes from the stack
//               );
//             },
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Welcome, Admin ${_model.username}!',
//               style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 20),
//             // View Requests Section
//             _buildSection(
//               context,
//               icon: Icons.add_circle,
//               title: 'View Requests',
//               description: 'Approve parking spaces.',
//               onTap: _navigateToReviewRequests,
//             ),
//             // Other sections...
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildSection(
//     BuildContext context, {
//     required IconData icon,
//     required String title,
//     required String description,
//     required VoidCallback onTap,
//   }) {
//     return Card(
//       margin: const EdgeInsets.only(bottom: 16.0),
//       child: ListTile(
//         leading: Icon(icon, size: 40),
//         title: Text(
//           title,
//           style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//         ),
//         subtitle: Text(description),
//         trailing: const Icon(Icons.arrow_forward),
//         onTap: onTap,
//       ),
//     );
//   }

//   void _navigateToReviewRequests() {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => Scaffold(
//           appBar: AppBar(title: const Text('Review Parking Spots')),
//           body: ListView.builder(
//             itemCount: _model.unverifiedSpots.length,
//             itemBuilder: (context, index) {
//               final spot = _model.unverifiedSpots[index];
//               return Card(
//                 child: ListTile(
//                   title: Text('Spot ID: ${spot['spot_id']}'),
//                   subtitle: Text(
//                     'Address: ${spot['location']}\nPricing: \$${spot['price']}',
//                   ),
//                   trailing: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       IconButton(
//                         icon: const Icon(Icons.check, color: Colors.green),
//                         onPressed: () => _reviewSpot(spot['spot_id'], "accept"), // Approve
//                       ),
//                       IconButton(
//                         icon: const Icon(Icons.close, color: Colors.red),
//                         onPressed: () => _reviewSpot(spot['spot_id'], "delete"), // Reject
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:login_app/View/manage_listing_screen.dart';
import 'package:login_app/View/manage_users_screen.dart';
import 'package:login_app/View/review_requests_screen.dart';
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
              subtitle: 'View reports & send alerts',
              navigateTo: const ManageNotificationsScreen(),
              
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
