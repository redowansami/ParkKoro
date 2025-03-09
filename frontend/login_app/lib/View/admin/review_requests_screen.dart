import 'package:flutter/material.dart';
import '../../controllers/admin_controller.dart';
import '../../models/admin_model.dart';

class ReviewRequestsScreen extends StatefulWidget {
  const ReviewRequestsScreen({super.key});

  @override
  _ReviewRequestsScreenState createState() => _ReviewRequestsScreenState();
}

class _ReviewRequestsScreenState extends State<ReviewRequestsScreen> {
  final AdminController _controller = AdminController();
  final AdminModel _model = AdminModel(username: '');
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUnverifiedSpots();
  }

  Future<void> _fetchUnverifiedSpots() async {
    try {
      List<dynamic> spots = await _controller.fetchUnverifiedSpots();
      setState(() {
        _model.updateUnverifiedSpots(spots);
        isLoading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _reviewSpot(int spotId, String action) async {
    try {
      await _controller.reviewSpot(spotId, action);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Spot $action successfully.')),
      );
      _fetchUnverifiedSpots(); // Refresh the list
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E3A8A), 
        title: const Text(
          'Review Parking Spots',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.5,
          ),
        ),
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
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : _model.unverifiedSpots.isEmpty
                ? const Center(
                    child: Text(
                      'No unverified spots available.',
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                : ListView.builder(
                    itemCount: _model.unverifiedSpots.length,
                    itemBuilder: (context, index) {
                      final spot = _model.unverifiedSpots[index];
                      return Card(
                        color: Colors.white.withOpacity(0.8), 
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          title: Text(
                            'Spot ID: ${spot['spot_id']}',
                            style: const TextStyle(
                              color: Color(0xFF1E3A8A), 
                            ),
                          ),
                          subtitle: Text(
                            'Address: ${spot['location']}\nPricing: \$${spot['price']}',
                            style: const TextStyle(
                              color: Colors.black87,
                            ),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.check,
                                  color: Colors.green,
                                ),
                                onPressed: () =>
                                    _reviewSpot(spot['spot_id'], "accept"),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.close,
                                  color: Colors.red,
                                ),
                                onPressed: () =>
                                    _reviewSpot(spot['spot_id'], "delete"),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}
