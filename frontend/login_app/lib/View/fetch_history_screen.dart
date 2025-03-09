import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BookingHistory {
  final String bookingId;
  final int spotId;
  final String bookingDate;
  final String amount;

  BookingHistory({
    required this.bookingId,
    required this.spotId,
    required this.bookingDate,
    required this.amount,
  });

  factory BookingHistory.fromJson(Map<String, dynamic> json) {
    return BookingHistory(
      bookingId: json['booking_id'],
      spotId: json['spot_id'],
      bookingDate: json['booking_date'],
      amount: json['amount'],
    );
  }
}

class FetchHistoryScreen extends StatefulWidget {
  final String renterId;

  FetchHistoryScreen({required this.renterId});

  @override
  _FetchHistoryScreenState createState() => _FetchHistoryScreenState();
}

class _FetchHistoryScreenState extends State<FetchHistoryScreen> {
  late Future<List<BookingHistory>> bookingHistory;

  Future<List<BookingHistory>> fetchBookingHistory(String renterId) async {
    final response = await http.get(Uri.parse('http://10.0.2.2:5000/booking_history/$renterId'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((booking) => BookingHistory.fromJson(booking)).toList();
    } else {
      throw Exception('Failed to load booking history');
    }
  }

  @override
  void initState() {
    super.initState();
    bookingHistory = fetchBookingHistory(widget.renterId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E3A8A), // Theme color
        title: const Text(
          "Booking History",
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
        child: FutureBuilder<List<BookingHistory>>(
          future: bookingHistory,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Error: ${snapshot.error}',
                  style: const TextStyle(color: Colors.white),
                ),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Text(
                  'No bookings found.',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              );
            } else {
              List<BookingHistory> bookings = snapshot.data!;
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: bookings.length,
                itemBuilder: (context, index) {
                  final booking = bookings[index];
                  return Card(
                    color: Colors.white.withOpacity(0.9), // Slight opacity for a smooth look
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 3,
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      title: Text(
                        'Booking ID: ${booking.bookingId}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E3A8A),
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          'Spot ID: ${booking.spotId}\n'
                          'Booking Date: ${booking.bookingDate}\n'
                          'Amount: ${booking.amount}',
                          style: const TextStyle(fontSize: 14, color: Colors.black87),
                        ),
                      ),
                      isThreeLine: true,
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
