import 'package:flutter/material.dart';
import '../controllers/register_controller.dart';
import '../models/register_model.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final RegisterController _controller = RegisterController();
  final RegisterModel _model = RegisterModel();
  bool _formVisible = false;
  bool _nidStepVisible = false;

  Future<void> _fetchVehicleOwnerData() async {
    try {
      final data = await _controller.fetchVehicleOwnerData(_model.nid);
      setState(() {
        _model.email = data['email'] ?? '';
        _model.phone = data['phone_number'] ?? '';
        _model.carType = data['car_type'] ?? '';
        _model.licensePlate = data['license_plate_number'] ?? '';
        _model.drivingLicense = data['driving_license_number'] ?? '';
        _formVisible = true;
        _nidStepVisible = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> _registerUser() async {
    try {
      await _controller.registerUser(_model);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User registered successfully.')),
      );
      Navigator.pop(context);
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
        title: Row(
          children: [
            Image.asset('assets/logo.png', height: 40),
            const SizedBox(width: 10),
            const Text('ParkKoro', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
          ],
        ),
        backgroundColor: const Color(0xFF1E40AF),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_model.userType.isEmpty) ...[
              const Text('Select User Type:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ListTile(
                title: const Text('Vehicle Owner'),
                leading: Radio<String>(
                  value: 'VehicleOwner',
                  groupValue: _model.userType,
                  onChanged: (value) {
                    setState(() {
                      _model.userType = value!;
                      _nidStepVisible = true;
                      _formVisible = false;
                    });
                  },
                ),
              ),
              ListTile(
                title: const Text('Space Owner'),
                leading: Radio<String>(
                  value: 'SpaceOwner',
                  groupValue: _model.userType,
                  onChanged: (value) {
                    setState(() {
                      _model.userType = value!;
                      _nidStepVisible = false;
                      _formVisible = true;
                    });
                  },
                ),
              ),
            ],
            if (_nidStepVisible) ...[
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  onChanged: (value) => _model.nid = value,
                  decoration: const InputDecoration(
                    labelText: 'Enter NID',
                    labelStyle: TextStyle(color: Colors.blue),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 15),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _fetchVehicleOwnerData,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E40AF),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Submit NID', style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
            ],
            if (_formVisible) ...[
              if (_model.userType == 'VehicleOwner') ...[
                Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  controller: TextEditingController(text: _model.nid),
                  decoration: const InputDecoration(
                    labelText: 'NID',
                    enabled: false,
                    labelStyle: TextStyle(color: Colors.black), // Label color set to black
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 15),
                  ),
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.5), // Darker text color for visibility
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  controller: TextEditingController(text: _model.email),
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    enabled: false,
                    labelStyle: TextStyle(color: Colors.black), // Label color set to black
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 15),
                  ),
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.5), // Darker text color for visibility
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  controller: TextEditingController(text: _model.phone),
                  decoration: const InputDecoration(
                    labelText: 'Phone Number',
                    enabled: false,
                    labelStyle: TextStyle(color: Colors.black), // Label color set to black
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 15),
                  ),
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.5), // Darker text color for visibility
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  controller: TextEditingController(text: _model.carType),
                  decoration: const InputDecoration(
                    labelText: 'Car Type',
                    enabled: false,
                    labelStyle: TextStyle(color: Colors.black), // Label color set to black
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 15),
                  ),
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.5), // Darker text color for visibility
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  controller: TextEditingController(text: _model.licensePlate),
                  decoration: const InputDecoration(
                    labelText: 'License Plate Number',
                    enabled: false,
                    labelStyle: TextStyle(color: Colors.black), // Label color set to black
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 15),
                  ),
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.5), // Darker text color for visibility
                  ),
                ),
              ),

                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextField(
                    controller: TextEditingController(text: _model.drivingLicense),
                    decoration: const InputDecoration(
                      labelText: 'Driving License Number',
                      enabled: false,
                      labelStyle: TextStyle(color: Colors.black), // Label color set to black
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 15),
                    ),
                    style: TextStyle(
                      color: Colors.black.withOpacity(.5), // Text color set to black (darker text)
                    ),
                  ),
                )
              ],
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  onChanged: (value) => _model.username = value,
                  decoration: const InputDecoration(
                    labelText: 'Username',
                    prefixIcon: Icon(Icons.person_outline, color: Colors.blue),
                    labelStyle: TextStyle(color: Colors.black),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 15),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  obscureText: true, // Apply the obscureText here
                  onChanged: (value) => _model.password = value,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock_outline, color: Colors.blue),
                    labelStyle: TextStyle(color: Colors.black),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 15),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              if (_model.userType != 'VehicleOwner') ...[
                Container(
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextField(
                    onChanged: (value) => _model.email = value,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email_outlined, color: Colors.blue),
                      labelStyle: TextStyle(color: Colors.black),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 15),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextField(
                    onChanged: (value) => _model.phone = value,
                    decoration: const InputDecoration(
                      labelText: 'Phone Number',
                      prefixIcon: Icon(Icons.phone_outlined, color: Colors.blue),
                      labelStyle: TextStyle(color: Colors.black),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 15),
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 20),
              Center(  // Centering the button
                child: ElevatedButton(
                  onPressed: _registerUser,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E40AF),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Register', style: TextStyle(fontSize: 16, color: Colors.white)),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
