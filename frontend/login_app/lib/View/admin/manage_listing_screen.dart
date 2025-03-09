import 'package:flutter/material.dart';
import '../../controllers/parking_spot_controller.dart';
import '../../models/parking_spot.dart';

class ManageListingsScreen extends StatefulWidget {
  const ManageListingsScreen({super.key});

  @override
  _ManageListingsScreenState createState() => _ManageListingsScreenState();
}

class _ManageListingsScreenState extends State<ManageListingsScreen> {
  final ParkingSpotController _controller = ParkingSpotController();
  List<ParkingSpot> parkingSpots = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchVerifiedSpots();
  }

  Future<void> _fetchVerifiedSpots() async {
    try {
      List<ParkingSpot> fetchedSpots = await _controller.fetchVerifiedSpots();
      setState(() {
        parkingSpots = fetchedSpots;
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

  Future<void> _deleteParkingSpot(int spotId) async {
    try {
      await _controller.deleteParkingSpot(spotId);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Parking spot deleted successfully.')),
      );
      _fetchVerifiedSpots(); 
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete parking spot: $e')),
      );
    }
  }

  void _showDeleteConfirmation(int spotId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const Text('Are you sure you want to delete this parking spot?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); 
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); 
                _deleteParkingSpot(spotId);
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E3A8A), 
        title: const Text(
          'Manage Parking Listings',
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
            : parkingSpots.isEmpty
                ? const Center(
                    child: Text(
                      'No verified parking spots available.',
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                : ListView.builder(
                    itemCount: parkingSpots.length,
                    itemBuilder: (context, index) {
                      final spot = parkingSpots[index];
                      return Card(
                        color: Colors.white.withOpacity(0.8), 
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          title: Text(
                            'Spot ID: ${spot.spotID}',
                            style: const TextStyle(
                              color: Color(0xFF1E3A8A), 
                            ),
                          ),
                          subtitle: Text(
                            'Location: ${spot.location}\nPrice: \$${spot.price}',
                            style: const TextStyle(
                              color: Colors.black87,
                            ),
                          ),
                          trailing: IconButton(
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                            onPressed: () => _showDeleteConfirmation(spot.spotID), 
                          ),
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}
