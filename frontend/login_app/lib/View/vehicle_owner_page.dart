import 'package:flutter/material.dart';
import 'package:login_app/View/booking_page.dart';
import 'package:login_app/View/edit_password_screen.dart';
import 'package:login_app/View/view_notification_screen.dart';
import '../controllers/parking_spot_controller.dart';
import '../models/parking_spot.dart';
import 'login_page.dart'; // Import the RegisterPage class
import 'google_map_page.dart'; // Import the GoogleMapPage

class VehicleOwnerPage extends StatefulWidget {
  final String username;
  const VehicleOwnerPage({super.key, required this.username});

  @override
  _VehicleOwnerPageState createState() => _VehicleOwnerPageState();
}

class _VehicleOwnerPageState extends State<VehicleOwnerPage> {
  final ParkingSpotController _controller = ParkingSpotController();
  List<ParkingSpot> verifiedSpots = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchVerifiedSpots();
  }

  Future<void> _fetchVerifiedSpots() async {
    setState(() => _isLoading = true);
    try {
      verifiedSpots = await _controller.fetchVerifiedSpots();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // Replace the entire navigation stack with login page
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
                (route) => false, // This will remove all routes from the stack
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Section
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.white.withOpacity(0.2),
                      child: Text(
                        widget.username[0].toUpperCase(),
                        style: const TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome back,',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                        Text(
                          widget.username,
                          style: const TextStyle(
                            fontSize: 24,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Quick Actions Section
              const Text(
                'Quick Actions',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              // Grid of Quick Actions
              GridView.count(
                crossAxisCount: 3,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildActionButton(
                    icon: Icons.search,
                    label: 'Find Parking',
                    onTap: _navigateToGoogleMapPage,
                    iconColor: Colors.blue,
                  ),
                  _buildActionButton(
                    icon: Icons.history,
                    label: 'History',
                    onTap: () {},
                    iconColor: Colors.purple,
                  ),
                  _buildActionButton(
                    icon: Icons.edit,
                    label: 'Change Password',
                    onTap: _editPassword,
                    iconColor: Colors.orange,
                  ),
                  _buildActionButton(
                    icon: Icons.star_outline,
                    label: 'Reviews',
                    onTap: () {},
                    iconColor: Colors.amber,
                  ),
                  _buildActionButton(
                    icon: Icons.cancel_outlined,
                    label: 'Cancel Booking',
                    onTap: () {},
                    iconColor: Colors.red,
                  ),
                  _buildActionButton(
                    icon: Icons.notifications,
                    label: 'Notifications',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ViewNotificationScreen()),
                      );
                    },
                    iconColor: Colors.green,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color? iconColor,
  }) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(50),
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: (iconColor ?? Theme.of(context).primaryColor).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 40,
              color: iconColor ?? Theme.of(context).primaryColor,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  void _editPassword() {
    // Navigate to Edit Password Screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditPasswordScreen(username: widget.username),
      ),
    );
  }

  // Function to navigate to the GoogleMapPage
  void _navigateToGoogleMapPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const GoogleMapPage()), // Navigate to the GoogleMapPage
    );
  }
}
