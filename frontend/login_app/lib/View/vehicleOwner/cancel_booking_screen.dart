import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// Updated constructor to accept username
class CancelBookingScreen extends StatefulWidget {
  final String username;  // Receive the username from the previous screen

  CancelBookingScreen({required this.username});

  @override
  _CancelBookingScreenState createState() => _CancelBookingScreenState();
}

class _CancelBookingScreenState extends State<CancelBookingScreen> {
  List<dynamic> futureBookings = [];

  @override
  void initState() {
    super.initState();
    fetchFutureBookings();
  }

  // Fetch future bookings for the specific user
  fetchFutureBookings() async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:5000/api/future_booking'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'renter_username': widget.username}),  // Pass the username from the widget
    );

    if (response.statusCode == 200) {
      setState(() {
        futureBookings = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load bookings');
    }
  }

  // Cancel booking and create refund request
  cancelBooking(String bookingId) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:5000/api/cancel_booking'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'booking_id': bookingId}),
    );

    if (response.statusCode == 200) {
      fetchFutureBookings(); // Refresh bookings
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Success'),
          content: Text('Booking canceled, refund request created.'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Failed to cancel booking or create refund request.'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cancel Bookings'),
      ),
      body: ListView.builder(
        itemCount: futureBookings.length,
        itemBuilder: (context, index) {
          var booking = futureBookings[index];
          return Card(
            child: ListTile(
              title: Text('Booking ID: ${booking['booking_id']}'),
              subtitle: Text('Start: ${booking['start_time']}\n End: ${booking['end_time']}\n Amount: ${booking['amount']}'),
              trailing: ElevatedButton(
                onPressed: () => cancelBooking(booking['booking_id']),
                child: Text('Cancel Booking'),
              ),
            ),
          );
        },
      ),
    );
  }
}
