import 'package:flutter/material.dart';
import '../controllers/register_controller.dart';
import '../models/register_model.dart';

class RegisterPage extends StatefulWidget {
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
      appBar: AppBar(title: Text('Register')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_model.userType.isEmpty) ...[
              Text('Select User Type:'),
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
              ListTile(
                title: const Text('Admin'),
                leading: Radio<String>(
                  value: 'Admin',
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
              TextField(
                onChanged: (value) => _model.nid = value,
                decoration: InputDecoration(labelText: 'Enter NID'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _fetchVehicleOwnerData,
                child: Text('Submit NID'),
              ),
            ],
            if (_formVisible) ...[
              if (_model.userType == 'VehicleOwner') ...[
                TextField(
                  controller: TextEditingController(text: _model.nid),
                  decoration: InputDecoration(labelText: 'NID'),
                  readOnly: true,
                ),
                TextField(
                  controller: TextEditingController(text: _model.email),
                  decoration: InputDecoration(labelText: 'Email'),
                  readOnly: true,
                ),
                TextField(
                  controller: TextEditingController(text: _model.phone),
                  decoration: InputDecoration(labelText: 'Phone Number'),
                  readOnly: true,
                ),
                TextField(
                  controller: TextEditingController(text: _model.carType),
                  decoration: InputDecoration(labelText: 'Car Type'),
                  readOnly: true,
                ),
                TextField(
                  controller: TextEditingController(text: _model.licensePlate),
                  decoration: InputDecoration(labelText: 'License Plate Number'),
                  readOnly: true,
                ),
                TextField(
                  controller: TextEditingController(text: _model.drivingLicense),
                  decoration: InputDecoration(labelText: 'Driving License Number'),
                  readOnly: true,
                ),
              ],
              TextField(
                onChanged: (value) => _model.username = value,
                decoration: InputDecoration(labelText: 'Username'),
              ),
              TextField(
                onChanged: (value) => _model.password = value,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              if (_model.userType != 'VehicleOwner') ...[
                TextField(
                  onChanged: (value) => _model.email = value,
                  decoration: InputDecoration(labelText: 'Email'),
                ),
                TextField(
                  onChanged: (value) => _model.phone = value,
                  decoration: InputDecoration(labelText: 'Phone Number'),
                ),
              ],
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _registerUser,
                child: Text('Register'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}