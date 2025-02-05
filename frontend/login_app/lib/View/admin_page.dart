import 'package:flutter/material.dart';
import '../controllers/admin_controller.dart';
import '../models/admin_model.dart';

class AdminPage extends StatefulWidget {
  final String username;

  const AdminPage({super.key, required this.username});

  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final AdminController _controller = AdminController();
  final AdminModel _model = AdminModel(username: '');

  @override
  void initState() {
    super.initState();
    _model.username = widget.username;
    _fetchUnverifiedSpots();
  }

  Future<void> _fetchUnverifiedSpots() async {
    try {
      final spots = await _controller.fetchUnverifiedSpots();
      setState(() {
        _model.updateUnverifiedSpots(spots);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch data: $e')),
      );
    }
  }

  Future<void> _reviewSpot(int id, String action) async {
  try {
    await _controller.reviewSpot(id, action); // Send "accept" or "delete"
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Action completed successfully.')),
    );
    _fetchUnverifiedSpots(); // Refresh the list
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to complete action: $e')),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
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
              'Welcome, Admin ${_model.username}!',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            // View Requests Section
            _buildSection(
              context,
              icon: Icons.add_circle,
              title: 'View Requests',
              description: 'Approve parking spaces.',
              onTap: _navigateToReviewRequests,
            ),
            // Other sections...
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

  void _navigateToReviewRequests() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(title: const Text('Review Parking Spots')),
          body: ListView.builder(
            itemCount: _model.unverifiedSpots.length,
            itemBuilder: (context, index) {
              final spot = _model.unverifiedSpots[index];
              return Card(
                child: ListTile(
                  title: Text('Spot ID: ${spot['spot_id']}'),
                  subtitle: Text(
                    'Address: ${spot['location']}\nPricing: \$${spot['price']}',
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.check, color: Colors.green),
                        onPressed: () => _reviewSpot(spot['id'], "accept"), // Approve
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.red),
                        onPressed: () => _reviewSpot(spot['id'], "delete"), // Reject
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
}