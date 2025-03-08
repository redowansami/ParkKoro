import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddCameraPage extends StatefulWidget {
  final String ownerId;

  // Constructor receives owner_id as parameter
  AddCameraPage({required this.ownerId});

  @override
  _AddCameraPageState createState() => _AddCameraPageState();
}

class _AddCameraPageState extends State<AddCameraPage> {
  final _urlController = TextEditingController();

  Future<void> addCamera() async {
    final url = Uri.parse('http://10.0.2.2:5000/add_camera');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'owner_id': widget.ownerId, // Use the passed owner_id
        'url': _urlController.text,
      }),
    );

    final responseData = json.decode(response.body);
    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(responseData['message'])));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(responseData['error'])));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Camera'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _urlController,
              decoration: InputDecoration(labelText: 'Camera URL'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: addCamera,
              child: Text('Add Camera'),
            ),
          ],
        ),
      ),
    );
  }
}
