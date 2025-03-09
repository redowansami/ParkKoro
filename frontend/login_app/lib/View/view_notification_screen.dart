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
        Uri.parse('http://10.0.2.2:5000/notifications/view'), // Update with actual backend URL
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
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E3A8A), // Theme color
        title: const Text(
          'Notifications',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
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
            ? const Center(child: CircularProgressIndicator())
            : notifications.isEmpty
                ? const Center(
                    child: Text(
                      'No notifications found',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: notifications.length,
                    itemBuilder: (context, index) {
                      final notification = notifications[index];
                      return Card(
                        color: Colors.white.withOpacity(0.9), // Slight opacity for a smooth look
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 3,
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16),
                          leading: const CircleAvatar(
                            backgroundColor: Color(0xFF1E3A8A),
                            child: Icon(Icons.notifications, color: Colors.white),
                          ),
                          title: Text(
                            notification['message_content'],
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1E3A8A),
                            ),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              'Date: ${notification['timestamp']}',
                              style: const TextStyle(fontSize: 14, color: Colors.black87),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}
