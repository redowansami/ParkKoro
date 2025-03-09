import 'package:flutter/material.dart';
import '../../controllers/parking_spot_controller.dart';
import '../../models/parking_spot.dart';

class AddListingScreen extends StatefulWidget {
  final String username;

  const AddListingScreen({super.key, required this.username});

  @override
  _AddListingScreenState createState() => _AddListingScreenState();
}

class _AddListingScreenState extends State<AddListingScreen> {
  final ParkingSpotController _controller = ParkingSpotController();
  late ParkingSpot _model;

  @override
  void initState() {
    super.initState();
    _model = ParkingSpot(
      spotID: 0,
      ownerID: widget.username,
      adminID: null,
      vehicleType: '',
      location: '',
      latitude: 0.0,
      longitude: 0.0,
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
        _model.spotID = 0;
        _model.latitude = 0.0;
        _model.longitude = 0.0;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E3A8A),
        title: const Text(
          'Register Parking Space',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Container(
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
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              color: Colors.white.withOpacity(0.9),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _buildTextField('Location', (value) => _model.location = value),
                    _buildNumberField('Latitude', (value) => _model.latitude = double.tryParse(value) ?? 0.0),
                    _buildNumberField('Longitude', (value) => _model.longitude = double.tryParse(value) ?? 0.0),
                    _buildNumberField('Price', (value) => _model.price = int.tryParse(value) ?? 0),
                    _buildTextField('Vehicle Type', (value) => _model.vehicleType = value),
                    _buildSwitch('EV Charging', _model.evCharging, (value) {
                      setState(() {
                        _model.evCharging = value;
                      });
                    }),
                    _buildSwitch('Surveillance', _model.surveillance, (value) {
                      setState(() {
                        _model.surveillance = value;
                      });
                    }),
                    _buildDropdown(),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _submitParkingSpot,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1E3A8A),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: const Text(
                          'Submit',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, Function(String) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF1E3A8A), width: 2),
          ),
        ),
      ),
    );
  }

  Widget _buildNumberField(String label, Function(String) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        onChanged: onChanged,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF1E3A8A), width: 2),
          ),
        ),
      ),
    );
  }

  Widget _buildSwitch(String label, bool value, Function(bool) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: const Color(0xFF1E3A8A),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DropdownButtonFormField<String>(
        value: _model.cancellationPolicy,
        onChanged: (String? newValue) {
          setState(() {
            _model.cancellationPolicy = newValue!;
          });
        },
        items: <String>['Strict', 'Moderate', 'Flexible']
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        decoration: InputDecoration(
          labelText: 'Cancellation Policy',
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF1E3A8A), width: 2),
          ),
        ),
      ),
    );
  }
}