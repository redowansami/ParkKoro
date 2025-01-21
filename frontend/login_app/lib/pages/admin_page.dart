// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class AdminPage extends StatefulWidget {
//   final String username;

//   const AdminPage({super.key, required this.username});

//   @override
//   _AdminPageState createState() => _AdminPageState();
// }

// class _AdminPageState extends State<AdminPage> {
//   List<dynamic> pendingSpots = [];

//   Future<void> fetchPendingSpots() async {
//     try {
//       final response = await http.get(
//         Uri.parse('http://127.0.0.1:5000/pending_parking_spots'),
//       );
//       if (response.statusCode == 200) {
//         setState(() {
//           pendingSpots = jsonDecode(response.body);
//         });
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to fetch data: $e')),
//       );
//     }
//   }

//   Future<void> reviewSpot(int id, String action) async {
//     try {
//       final response = await http.post(
//         Uri.parse('http://127.0.0.1:5000/review_parking_spot/$id'),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({'action': action}),
//       );
//       if (response.statusCode == 200) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Action completed successfully.')),
//         );
//         fetchPendingSpots(); // Refresh list
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to complete action: $e')),
//       );
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     fetchPendingSpots();
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
//           style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//         ),
//         subtitle: Text(description),
//         trailing: Icon(Icons.arrow_forward),
//         onTap: onTap,
//       ),
//     );
//   }

//   void _navigateToReviewRequests() {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => Scaffold(
//           appBar: AppBar(title: Text('Review Parking Spots')),
//           body: ListView.builder(
//             itemCount: pendingSpots.length,
//             itemBuilder: (context, index) {
//               final spot = pendingSpots[index];
//               return Card(
//                 child: ListTile(
//                   title: Text(spot['address']),
//                   subtitle: Text('Pricing: \$${spot['pricing']}'),
//                   trailing: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       IconButton(
//                         icon: Icon(Icons.check, color: Colors.green),
//                         onPressed: () => reviewSpot(spot['id'], 'approve'),
//                       ),
//                       IconButton(
//                         icon: Icon(Icons.close, color: Colors.red),
//                         onPressed: () => reviewSpot(spot['id'], 'reject'),
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

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Admin Dashboard'),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.logout),
//             onPressed: () {
//               Navigator.pop(context); // Log out functionality
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
//               'Welcome, Admin ${widget.username}!',
//               style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 20),

//             // View Requests Section
//             _buildSection(
//               context,
//               icon: Icons.add_circle,
//               title: 'View Requests',
//               description: 'Approve parking spaces.',
//               onTap: _navigateToReviewRequests,
//             ),

//             // Remove Parking Space Section
//             _buildSection(
//               context,
//               icon: Icons.delete,
//               title: 'Remove Parking Space',
//               description: 'Delete or suspend non-compliant parking spaces.',
//               onTap: () {
//                 // Implement remove parking space functionality
//               },
//             ),

//             // Handle Complaints Section
//             _buildSection(
//               context,
//               icon: Icons.report_problem,
//               title: 'Handle Complaints',
//               description: 'View and address user complaints.',
//               onTap: () {
//                 // Implement handle complaints functionality
//               },
//             ),

//             // Add Announcements Section
//             _buildSection(
//               context,
//               icon: Icons.campaign,
//               title: 'Add Announcements',
//               description: 'Send notifications or announcements.',
//               onTap: () {
//                 // Implement add announcements functionality
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AdminPage extends StatefulWidget {
  final String username;

  const AdminPage({super.key, required this.username});

  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  List<dynamic> unverifiedSpots = [];

  // Fetch unverified parking spots
  Future<void> fetchUnverifiedSpots() async {
    try {
      final response = await http.get(
        Uri.parse('http://127.0.0.1:5000/unverified_parking_spots'),
      );
      if (response.statusCode == 200) {
        setState(() {
          unverifiedSpots = jsonDecode(response.body);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch data: $e')),
      );
    }
  }

  // Review and update verification status
  Future<void> reviewSpot(int id, bool approve) async {
    try {
      final response = await http.post(
        Uri.parse('http://127.0.0.1:5000/review_parking_spot/$id'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'action': approve ? 'approve' : 'reject'}), // Send approve or reject
      );
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Action completed successfully.')),
        );
        fetchUnverifiedSpots(); // Refresh the list
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to complete action: ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to complete action: $e')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUnverifiedSpots();
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

  void _navigateToReviewRequests() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(title: Text('Review Parking Spots')),
          body: ListView.builder(
            itemCount: unverifiedSpots.length,
            itemBuilder: (context, index) {
              final spot = unverifiedSpots[index];
              return Card(
                child: ListTile(
                  title: Text('Spot ID: ${spot['spot_id']}'),
                  subtitle: Text(
                    'Address: ${spot['address']}\nPricing: \$${spot['pricing']}',
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.check, color: Colors.green),
                        onPressed: () => reviewSpot(spot['id'], true), // Approve
                      ),
                      IconButton(
                        icon: Icon(Icons.close, color: Colors.red),
                        onPressed: () => reviewSpot(spot['id'], false), // Reject
                      ),
                    ],
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
              'Welcome, Admin ${widget.username}!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),

            // View Requests Section
            _buildSection(
              context,
              icon: Icons.add_circle,
              title: 'View Requests',
              description: 'Approve parking spaces.',
              onTap: _navigateToReviewRequests,
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
}
