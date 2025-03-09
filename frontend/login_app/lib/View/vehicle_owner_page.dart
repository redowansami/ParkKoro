import 'package:flutter/material.dart';
import 'package:login_app/View/edit_password_screen.dart';
import 'package:login_app/View/fetch_history_screen.dart';
import 'package:login_app/View/vehicleOwner/add_review_screen.dart';
import 'package:login_app/View/vehicleOwner/cancel_booking_screen.dart';
import 'package:login_app/View/view_notification_screen.dart';
import '../controllers/parking_spot_controller.dart';
import '../models/parking_spot.dart';
import 'login_page.dart';
import 'google_map_page.dart';

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
      body: Stack(
        children: [
          // Full-Screen Gradient Background
          Container(
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
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // App Bar with Logo
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Image.asset(
                            'assets/logo.png', // Path to your logo inside assets folder
                            height: 32, // Adjust size as needed
                            fit: BoxFit.contain,
                          ),
                          const SizedBox(width: 10), // Space between logo and text
                          const Text(
                            'Vehicle Owner Dashboard',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
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
                ),

                // Welcome Section
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.white.withOpacity(0.3),
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
                ),

                const SizedBox(height: 24),

                // Quick Actions Section
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Select an action',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Grid of Quick Actions
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: GridView.count(
                      crossAxisCount: 3,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        _buildActionButton(Icons.search, "Find Parking", _navigateToGoogleMapPage, Colors.blue),
                        _buildActionButton(Icons.bookmark, "Pre-Book", () {}, const Color.fromARGB(255, 239, 183, 0)),
                        _buildActionButton(Icons.history, "History", () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FetchHistoryScreen(renterId: widget.username),
                            ),
                          );
                        }, Colors.purple),
                        _buildActionButton(Icons.edit, "Change Password", _editPassword, Colors.orange),
                        _buildActionButton(Icons.star_outline, "Reviews", () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddReviewScreen(username: widget.username),
                            ),
                          );
                        }, Colors.amber),
                        _buildActionButton(Icons.cancel_outlined, "Cancel Booking", () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CancelBookingScreen(username: widget.username),
                            ),
                          );
                        }, Colors.red),
                        _buildActionButton(Icons.notifications, "Notifications", () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const ViewNotificationScreen()),
                          );
                        }, const Color.fromARGB(255, 10, 238, 18)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label, VoidCallback onTap, Color iconColor) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        height: 100,
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.3), // White with 0.3 opacity
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Center the icon and text
          children: [
            Icon(icon, size: 32, color: iconColor), // Keep original icon color
            const SizedBox(height: 8), // Space between icon and text
            Text(
              label,
              textAlign: TextAlign.center, // Ensure text is centered
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white, // White text for visibility
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _editPassword() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditPasswordScreen(username: widget.username),
      ),
    );
  }

  void _navigateToGoogleMapPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => GoogleMapPage(username: widget.username)),
    );
  }
}
