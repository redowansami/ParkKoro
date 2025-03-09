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
      Uri.parse('http://10.0.2.2:5000/get_profile_info'), // Adjust the backend URL accordingly
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
      Uri.parse('http://10.0.2.2:5000/update_profile'), // Backend URL for updating profile
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
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E3A8A),
        title: const Text(
          'Edit Profile',
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
          child: isLoading
              ? const Center(child: CircularProgressIndicator(color: Colors.white))
              : SingleChildScrollView(
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'NID: $nid',
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Email: $email',
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Phone: $phone',
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
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
                                      title: const Text("Update Profile Information"),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          TextField(
                                            controller: nidController,
                                            decoration: InputDecoration(
                                              labelText: "NID",
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
                                          const SizedBox(height: 10),
                                          TextField(
                                            controller: emailController,
                                            decoration: InputDecoration(
                                              labelText: "Email",
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
                                          const SizedBox(height: 10),
                                          TextField(
                                            controller: phoneController,
                                            decoration: InputDecoration(
                                              labelText: "Phone",
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
                                          child: const Text(
                                            "Update",
                                            style: TextStyle(color: Color(0xFF1E3A8A)),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF1E3A8A),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.symmetric(vertical: 14),
                              ),
                              child: const Text(
                                'Update Profile Information',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () => _navigateToChangePassword(context),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF1E3A8A),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.symmetric(vertical: 14),
                              ),
                              child: const Text(
                                'Change Password',
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
}