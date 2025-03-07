import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:login_app/View/edit_password_screen.dart';
import 'dart:convert';

class EditProfileScreen extends StatefulWidget {
  final String username;

  const EditProfileScreen({Key? key, required this.username}) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  bool isLoading = true;
  String nid = '';
  String email = '';
  String phone = '';

  @override
  void initState() {
    super.initState();
    fetchProfileInfo();
  }

  // Function to fetch the current profile information
  Future<void> fetchProfileInfo() async {
    final response = await http.post(
      Uri.parse('http://127.0.0.1:5000/get_profile_info'), // Adjust the backend URL accordingly
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': widget.username}),
    );

    if (response.statusCode == 200) {
      final profileData = jsonDecode(response.body);
      setState(() {
        nid = profileData['nid'];
        email = profileData['email'];
        phone = profileData['phone'];
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load profile data.')),
      );
    }
  }

  // Function to update the profile information
  Future<void> updateProfile(String nid, String email, String phone) async {
    final response = await http.put(
      Uri.parse('http://127.0.0.1:5000/update_profile'), // Backend URL for updating profile
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': widget.username,
        'nid': nid,
        'email': email,
        'phone': phone,
      }),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile updated successfully!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update profile.')),
      );
    }
  }

  void _navigateToChangePassword(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditPasswordScreen(username: widget.username)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Edit Profile")),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('NID: $nid'),
                  Text('Email: $email'),
                  Text('Phone: $phone'),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Update Profile Information
                      showDialog(
                        context: context,
                        builder: (context) {
                          TextEditingController nidController =
                              TextEditingController(text: nid);
                          TextEditingController emailController =
                              TextEditingController(text: email);
                          TextEditingController phoneController =
                              TextEditingController(text: phone);

                          return AlertDialog(
                            title: Text("Update Profile Information"),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextField(
                                  controller: nidController,
                                  decoration: InputDecoration(labelText: "NID"),
                                ),
                                TextField(
                                  controller: emailController,
                                  decoration: InputDecoration(labelText: "Email"),
                                ),
                                TextField(
                                  controller: phoneController,
                                  decoration: InputDecoration(labelText: "Phone"),
                                ),
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  updateProfile(
                                    nidController.text,
                                    emailController.text,
                                    phoneController.text,
                                  );
                                  Navigator.pop(context); // Close the dialog
                                },
                                child: Text("Update"),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Text('Update Profile Information'),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => _navigateToChangePassword(context),
                    child: Text('Change Password'),
                  ),
                ],
              ),
            ),
    );
  }
}
