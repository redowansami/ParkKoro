import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SendNotificationScreen extends StatefulWidget {
  const SendNotificationScreen({super.key});

  @override
  _SendNotificationScreenState createState() => _SendNotificationScreenState();
}

class _SendNotificationScreenState extends State<SendNotificationScreen> {
  final TextEditingController _messageController = TextEditingController();
  bool _isSending = false;

  Future<void> _sendNotification() async {
    if (_messageController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Message cannot be empty')),
      );
      return;
    }

    setState(() {
      _isSending = true;
    });

    try {
      final response = await http.post(
        Uri.parse('http://127.0.0.1:5000/notifications/send'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"message_content": _messageController.text}),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Notification sent successfully!')),
        );
        _messageController.clear();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to send notification: ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        _isSending = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Send Notification')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Enter Notification Message:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            TextField(
              controller: _messageController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Enter message...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isSending ? null : _sendNotification,
                child: _isSending ? const CircularProgressIndicator() : const Text('Send Notification'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
