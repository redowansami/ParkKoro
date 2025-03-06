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
      _fetchVerifiedSpots(); // Refresh list after deletion
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete parking spot: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manage Parking Listings')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : parkingSpots.isEmpty
              ? const Center(child: Text('No verified parking spots available.'))
              : ListView.builder(
                  itemCount: parkingSpots.length,
                  itemBuilder: (context, index) {
                    final spot = parkingSpots[index];
                    return Card(
                      child: ListTile(
                        title: Text('Spot ID: ${spot.spotID}'),
                        subtitle: Text('Location: ${spot.location}\nPrice: \$${spot.price}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteParkingSpot(spot.spotID),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
