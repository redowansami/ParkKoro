import 'package:flutter/material.dart';
import '../controllers/space_owner_controller.dart';
import '../models/space_owner_model.dart';

class SpaceOwnerPage extends StatefulWidget {
  final String username;

  const SpaceOwnerPage({super.key, required this.username});

  @override
  _SpaceOwnerPageState createState() => _SpaceOwnerPageState();
}

class _SpaceOwnerPageState extends State<SpaceOwnerPage> {
  final SpaceOwnerController _controller = SpaceOwnerController();
  final SpaceOwnerModel _model = SpaceOwnerModel();

  Future<void> _submitParkingSpot() async {
    try {
      await _controller.submitParkingSpot(_model);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Parking spot submitted for review.')),
      );
      setState(() {
        _model.spotId = '';
        _model.gpsCoordinates = '';
        _model.address = '';
        _model.pricing = 0.0;
        _model.evCharging = false;
        _model.surveillance = false;
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

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Register Parking Space'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      onChanged: (value) => _model.spotId = value,
                      decoration: InputDecoration(labelText: 'Spot ID'),
                    ),
                    TextField(
                      onChanged: (value) => _model.gpsCoordinates = value,
                      decoration: InputDecoration(labelText: 'GPS Coordinates'),
                    ),
                    TextField(
                      onChanged: (value) => _model.address = value,
                      decoration: InputDecoration(labelText: 'Address'),
                    ),
                    TextField(
                      onChanged: (value) => _model.pricing = double.parse(value),
                      decoration: InputDecoration(labelText: 'Pricing'),
                      keyboardType: TextInputType.number,
                    ),
                    Row(
                      children: [
                        Text('EV Charging'),
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
                        Text('Surveillance'),
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
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _model.evCharging = localEvCharging;
                      _model.surveillance = localSurveillance;
                    });
                    Navigator.pop(context);
                    _submitParkingSpot();
                  },
                  child: Text('Submit'),
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
        title: Text('Space Owner Dashboard'),
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
              'Welcome, ${widget.username}!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
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
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(description),
        trailing: Icon(Icons.arrow_forward),
        onTap: onTap,
      ),
    );
  }
}