import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CancelBookingScreen extends StatefulWidget {
  final String username;

  CancelBookingScreen({required this.username});

  @override
  _CancelBookingScreenState createState() => _CancelBookingScreenState();
}

class _CancelBookingScreenState extends State<CancelBookingScreen> {
  List<dynamic> futureBookings = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchFutureBookings();
  }

  Future<void> fetchFutureBookings() async {
    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:5000/api/future_booking'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'renter_username': widget.username}),
      );

      if (response.statusCode == 200) {
        setState(() {
          futureBookings = json.decode(response.body);
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load bookings');
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

  Future<void> cancelBooking(String bookingId) async {
    bool confirmCancel = await _showConfirmationDialog(bookingId);
    if (!confirmCancel) return;

    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:5000/api/cancel_booking'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'booking_id': bookingId}),
      );

      if (response.statusCode == 200) {
        fetchFutureBookings(); // Refresh bookings
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Booking canceled, refund request created.')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to cancel booking or create refund request.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<bool> _showConfirmationDialog(String bookingId) async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Cancellation'),
        content: Text('Are you sure you want to cancel booking ID: $bookingId?'),
        actions: <Widget>[
          TextButton(
            child: const Text('No', style: TextStyle(color: Colors.red)),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          TextButton(
            child: const Text('Yes'),
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    ) ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E3A8A), 
        title: const Text(
          'Cancel Bookings',
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
            : futureBookings.isEmpty
                ? const Center(
                    child: Text(
                      'No future bookings found',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: futureBookings.length,
                    itemBuilder: (context, index) {
                      final booking = futureBookings[index];
                      return Card(
                        color: Colors.white.withOpacity(0.9), // Slight opacity for a smooth look
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 3,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Booking ID: ${booking['booking_id']}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1E3A8A),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Start: ${booking['start_time']}\n'
                                'End: ${booking['end_time']}\n'
                                'Amount: ${booking['amount']}',
                                style: const TextStyle(fontSize: 14, color: Colors.black87),
                              ),
                              const SizedBox(height: 12),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () => cancelBooking(booking['booking_id']),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.redAccent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                  ),
                                  child: const Text(
                                    'Cancel Booking',
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}
