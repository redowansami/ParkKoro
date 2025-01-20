// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: LoginPage(),
//     );
//   }
// }

// class LoginPage extends StatefulWidget {
//   const LoginPage({super.key});

//   @override
//   _LoginPageState createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   final TextEditingController _usernameController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();

//   Future<void> loginUser() async {
//   final String username = _usernameController.text;
//   final String password = _passwordController.text;

//   if (username.isEmpty || password.isEmpty) {
//     if (mounted) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please fill in all fields.')),
//       );
//     }
//     return;
//   }

//   try {
//     final response = await http.post(
//       Uri.parse('http://127.0.0.1:5000/login'),
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode({'username': username, 'password': password}),
//     );

//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);
//       final String userType = data['user_type'];

//       if (mounted) {
//         if (userType == 'VehicleOwner') {
//           Navigator.push(context, MaterialPageRoute(builder: (context) => VehicleOwnerPage()));
//         } else if (userType == 'SpaceOwner') {
//           Navigator.push(context, MaterialPageRoute(builder: (context) => SpaceOwnerPage()));
//         } else if (userType == 'Admin') {
//           Navigator.push(context, MaterialPageRoute(builder: (context) => AdminPage()));
//         }
//       }
//     } else {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Invalid credentials.')),
//         );
//       }
//     }
//   } catch (e) {
//     if (mounted) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('An error occurred: $e')),
//       );
//     }
//   }
// }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Login')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(
//               controller: _usernameController,
//               decoration: InputDecoration(labelText: 'Username'),
//             ),
//             TextField(
//               controller: _passwordController,
//               decoration: InputDecoration(labelText: 'Password'),
//               obscureText: true,
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: loginUser,
//               child: Text('Login'),
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterPage()));
//               },
//               child: Text('Don\'t have an account? Register'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }



// class RegisterPage extends StatefulWidget {
//   @override
//   _RegisterPageState createState() => _RegisterPageState();
// }

// class _RegisterPageState extends State<RegisterPage> {
//   final TextEditingController _nidController = TextEditingController();
//   final TextEditingController _usernameController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _phoneController = TextEditingController();
//   final TextEditingController _carTypeController = TextEditingController();
//   final TextEditingController _licensePlateController = TextEditingController();
//   final TextEditingController _drivingLicenseController = TextEditingController();

//   String _selectedUserType = '';
//   bool _formVisible = false;
//   bool _nidStepVisible = false;

//   Future<void> fetchVehicleOwnerData(String nid) async {
//     try {
//       final response = await http.get(
//         Uri.parse('http://127.0.0.1:5000/brta?nid=$nid'),
//       );

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         setState(() {
//           _emailController.text = data['email'] ?? '';
//           _phoneController.text = data['phone_number'] ?? '';
//           _carTypeController.text = data['car_type'] ?? '';
//           _licensePlateController.text = data['license_plate_number'] ?? '';
//           _drivingLicenseController.text = data['driving_license_number'] ?? '';
//           _formVisible = true;
//           _nidStepVisible = false;
//         });
//       } else {
//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text('Failed to fetch data: ${response.reasonPhrase}')),
//           );
//         }
//       }
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('An error occurred: $e')),
//         );
//       }
//     }
//   }

//   Future<void> registerUser() async {
//     final String username = _usernameController.text;
//     final String password = _passwordController.text;
//     final String nid = _nidController.text;
//     final String email = _emailController.text;
//     final String phone = _phoneController.text;
//     final String carType = _carTypeController.text;
//     final String licensePlate = _licensePlateController.text;
//     final String drivingLicense = _drivingLicenseController.text;

//     if (_selectedUserType.isEmpty || username.isEmpty || password.isEmpty) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Please fill in all required fields.')),
//         );
//       }
//       return;
//     }

//     try {
//       final response = await http.post(
//         Uri.parse('http://127.0.0.1:5000/register'),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({
//           'username': username,
//           'password': password,
//           'user_type': _selectedUserType,
//           'nid': _selectedUserType == 'VehicleOwner' ? nid : null,
//           'email': email,
//           'phone': phone,
//           'car_type': _selectedUserType == 'VehicleOwner' ? carType : null,
//           'license_plate_number': _selectedUserType == 'VehicleOwner' ? licensePlate : null,
//           'driving_license_number': _selectedUserType == 'VehicleOwner' ? drivingLicense : null,
//         }),
//       );

//       if (response.statusCode == 201) {
//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text('User registered successfully.')),
//           );
//           Navigator.pop(context);
//         }
//       } else {
//         final data = jsonDecode(response.body);
//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text(data['message'] ?? 'Registration failed.')),
//           );
//         }
//       }
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('An error occurred: $e')),
//         );
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Register')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             if (_selectedUserType.isEmpty) ...[
//               Text('Select User Type:'),
//               ListTile(
//                 title: const Text('Vehicle Owner'),
//                 leading: Radio<String>(
//                   value: 'VehicleOwner',
//                   groupValue: _selectedUserType,
//                   onChanged: (value) {
//                     setState(() {
//                       _selectedUserType = value!;
//                       _nidStepVisible = true;
//                       _formVisible = false;
//                     });
//                   },
//                 ),
//               ),
//               ListTile(
//                 title: const Text('Space Owner'),
//                 leading: Radio<String>(
//                   value: 'SpaceOwner',
//                   groupValue: _selectedUserType,
//                   onChanged: (value) {
//                     setState(() {
//                       _selectedUserType = value!;
//                       _nidStepVisible = false;
//                       _formVisible = true;
//                     });
//                   },
//                 ),
//               ),
//               ListTile(
//                 title: const Text('Admin'),
//                 leading: Radio<String>(
//                   value: 'Admin',
//                   groupValue: _selectedUserType,
//                   onChanged: (value) {
//                     setState(() {
//                       _selectedUserType = value!;
//                       _nidStepVisible = false;
//                       _formVisible = true;
//                     });
//                   },
//                 ),
//               ),
//             ],

//             if (_nidStepVisible) ...[
//               TextField(
//                 controller: _nidController,
//                 decoration: InputDecoration(labelText: 'Enter NID'),
//               ),
//               SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: () {
//                   fetchVehicleOwnerData(_nidController.text);
//                 },
//                 child: Text('Submit NID'),
//               ),
//             ],

//             if (_formVisible) ...[
//               if (_selectedUserType == 'VehicleOwner') ...[
//                 TextField(
//                   controller: _nidController,
//                   decoration: InputDecoration(labelText: 'NID'),
//                   readOnly: true,
//                 ),
//                 TextField(
//                   controller: _emailController,
//                   decoration: InputDecoration(labelText: 'Email'),
//                   readOnly: true,
//                 ),
//                 TextField(
//                   controller: _phoneController,
//                   decoration: InputDecoration(labelText: 'Phone Number'),
//                   readOnly: true,
//                 ),
//                 TextField(
//                   controller: _carTypeController,
//                   decoration: InputDecoration(labelText: 'Car Type'),
//                   readOnly: true,
//                 ),
//                 TextField(
//                   controller: _licensePlateController,
//                   decoration: InputDecoration(labelText: 'License Plate Number'),
//                   readOnly: true,
//                 ),
//                 TextField(
//                   controller: _drivingLicenseController,
//                   decoration: InputDecoration(labelText: 'Driving License Number'),
//                   readOnly: true,
//                 ),
//               ],

//               TextField(
//                 controller: _usernameController,
//                 decoration: InputDecoration(labelText: 'Username'),
//               ),
//               TextField(
//                 controller: _passwordController,
//                 decoration: InputDecoration(labelText: 'Password'),
//                 obscureText: true,
//               ),

//               if (_selectedUserType != 'VehicleOwner') ...[
//                 TextField(
//                   controller: _emailController,
//                   decoration: InputDecoration(labelText: 'Email'),
//                 ),
//                 TextField(
//                   controller: _phoneController,
//                   decoration: InputDecoration(labelText: 'Phone Number'),
//                 ),
//               ],

//               SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: registerUser,
//                 child: Text('Register'),
//               ),
//             ],
//           ],
//         ),
//       ),
//     );
//   }
// }


// class VehicleOwnerPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Vehicle Owner Dashboard')),
//       body: Center(child: Text('Welcome, Vehicle Owner!')),
//     );
//   }
// }

// class SpaceOwnerPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Space Owner Dashboard')),
//       body: Center(child: Text('Welcome, Space Owner!')),
//     );
//   }
// }

// class AdminPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Admin Dashboard')),
//       body: Center(child: Text('Welcome, Admin!')),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'pages/login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}
