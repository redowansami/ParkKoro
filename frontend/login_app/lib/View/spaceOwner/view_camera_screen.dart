import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

class ViewCameraPage extends StatefulWidget {
  final String ownerId;

  ViewCameraPage({required this.ownerId});

  @override
  _ViewCameraPageState createState() => _ViewCameraPageState();
}

class _ViewCameraPageState extends State<ViewCameraPage> {
  List<dynamic> cameras = [];

  Future<void> fetchCameras() async {
    final url = Uri.parse('http://10.0.2.2:5000/view_cameras/${widget.ownerId}');
    final response = await http.get(url);

    final responseData = json.decode(response.body);
    if (response.statusCode == 200) {
      setState(() {
        cameras = responseData;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(responseData['message'])));
    }
  }

  Future<void> launchURL(String url) async {
    
    final uri = Uri.parse(url); 
    final host = uri.host; 
    final path = uri.path; 
    
    launchUrl(Uri.https(host, path));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Cameras'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: fetchCameras,
              child: Text('Fetch Cameras'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: cameras.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('Camera ${cameras[index]['camera_id']}'),
                    subtitle: Text(cameras[index]['url']),
                    onTap: () async {
                      launchUrl(Uri.parse(cameras[index]['url']));  
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}