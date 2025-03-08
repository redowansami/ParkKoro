import 'package:flutter/material.dart';
import 'package:login_app/View/spaceOwner/add_camera_screen.dart';
import 'package:login_app/View/spaceOwner/view_camera_screen.dart';

class SurveillanceScreenPage extends StatelessWidget {
  final String username;

  // Constructor to accept username
  SurveillanceScreenPage({required this.username});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Surveillance Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // Navigate to the Add Camera page, passing the username
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddCameraPage(ownerId: username),
                  ),
                );
              },
              child: Text('Add Camera'),
            ),
            ElevatedButton(
              onPressed: () {
                // Navigate to the View Camera page, passing the username
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ViewCameraPage(ownerId: username),
                  ),
                );
              },
              child: Text('View Camera'),
            ),
          ],
        ),
      ),
    );
  }
}
