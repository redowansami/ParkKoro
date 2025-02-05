import 'package:flutter/material.dart';
import '../controllers/parking_spot_controller.dart';
import '../models/parking_spot.dart'; // Updated to use ParkingSpot model

class SpaceOwnerPage extends StatefulWidget {
  final String username;

  const SpaceOwnerPage({super.key, required this.username});

  @override
  _SpaceOwnerPageState createState() => _SpaceOwnerPageState();
}

class _SpaceOwnerPageState extends State<SpaceOwnerPage> {
  final ParkingSpotController _controller = ParkingSpotController();
  late ParkingSpot _model; // Declare _model as late to initialize it in initState

  @override
  void initState() {
    super.initState();
    // Initialize _model with the username as ownerID
    _model = ParkingSpot(
      spotID: '',
      ownerID: widget.username, // Set ownerID to the username
      adminID: null,
      vehicleType: '',
      location: '',
      gpsCoordinates: '',
      price: 0,
      evCharging: false,
      surveillance: false,
      cancellationPolicy: 'Strict',
      availabilityStatus: true,
    );
  }

  Future<void> _submitParkingSpot() async {
    try {
      await _controller.submitParkingSpot(_model);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Parking spot submitted for review.')),
      );
      setState(() {
        _model.spotID = '';
        _model.gpsCoordinates = '';
        _model.location = '';
        _model.price = 0;
        _model.evCharging = false;
        _model.surveillance = false;
        _model.vehicleType = '';
        _model.cancellationPolicy = 'Strict';
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  void _showRegisterSpaceDialog() {
    bool localEvCharging = _model.evCharging;
    bool localSurveillance = _model.surveillance;
    String localCancellationPolicy = _model.cancellationPolicy;

    showDialog(
  context: context,
  builder: (context) {
    return StatefulBuilder(
      builder: (context, setState) {
        return AlertDialog(
          title: const Text('Register Parking Space'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  onChanged: (value) => _model.spotID = value,
                  decoration: const InputDecoration(labelText: 'Spot ID'),
                ),
                TextField(
                  onChanged: (value) => _model.gpsCoordinates = value,
                  decoration: const InputDecoration(labelText: 'GPS Coordinates'),
                ),
                TextField(
                  onChanged: (value) => _model.location = value,
                  decoration: const InputDecoration(labelText: 'Location'),
                ),
                TextField(
                  onChanged: (value) => _model.location = value,
                  decoration: const InputDecoration(labelText: 'Address'),
                ),
                TextField(
                  onChanged: (value) => _model.price = int.parse(value),
                  decoration: const InputDecoration(labelText: 'Price'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  onChanged: (value) => _model.vehicleType = value,
                  decoration: const InputDecoration(labelText: 'Vehicle Type'),
                ),
                Row(
                  children: [
                    const Text('EV Charging'),
                    Switch(
                      value: localEvCharging,
                      onChanged: (value) {
                        setState(() {
                          localEvCharging = value;
                        });
                      },
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Text('Surveillance'),
                    Switch(
                      value: localSurveillance,
                      onChanged: (value) {
                        setState(() {
                          localSurveillance = value;
                        });
                      },
                    ),
                  ],
                ),
                DropdownButton<String>(
                  value: localCancellationPolicy,
                  onChanged: (String? newValue) {
                    setState(() {
                      localCancellationPolicy = newValue!;
                    });
                  },
                  items: <String>['Strict', 'Moderate', 'Flexible']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                // Auto-filled, non-editable TextField for ownerID
                TextField(
                  readOnly: true, // Make the field non-editable
                  controller: TextEditingController(text: _model.ownerID), // Auto-fill with ownerID
                  decoration: const InputDecoration(
                    labelText: 'Owner ID',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _model.evCharging = localEvCharging;
                  _model.surveillance = localSurveillance;
                  _model.cancellationPolicy = localCancellationPolicy;
                });
                Navigator.pop(context);
                _submitParkingSpot();
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  },
);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Space Owner Dashboard'),
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
              'Welcome, ${widget.username}!',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            _buildSection(
              context,
              icon: Icons.add_location_alt,
              title: 'Register Space',
              description: 'List a new parking space for customers.',
              onTap: _showRegisterSpaceDialog,
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
}