import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ViewNotificationScreen extends StatefulWidget {
  const ViewNotificationScreen({super.key});

  @override
  _ViewNotificationScreenState createState() => _ViewNotificationScreenState();
}

class _ViewNotificationScreenState extends State<ViewNotificationScreen> {
  List<dynamic> notifications = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchNotifications();
  }

  Future<void> _fetchNotifications() async {
    try {
      final response = await http.get(
        Uri.parse('http://127.0.0.1:5000/notifications/view'), // Update with actual backend URL
      );

      if (response.statusCode == 200) {
        setState(() {
          notifications = jsonDecode(response.body)['notifications'];
          isLoading = false;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load notifications: ${response.body}')),
        );
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : notifications.isEmpty
              ? const Center(child: Text('No notifications found'))
              : ListView.builder(
                  itemCount: notifications.length,
                  itemBuilder: (context, index) {
                    final notification = notifications[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: ListTile(
                        leading: const Icon(Icons.notifications, color: Colors.blue),
                        title: Text(
                          notification['message_content'],
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text('Date: ${notification['timestamp']}'),
                      ),
                    );
                  },
                ),
    );
  }
}
