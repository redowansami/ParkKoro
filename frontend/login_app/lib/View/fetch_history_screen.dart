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
      amount: json['amount'],  // Removed cancellation_status
    );
  }
}

class FetchHistoryScreen extends StatefulWidget {
  final String renterId;  // Pass renter_id when navigating

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
      appBar: AppBar(title: Text("Booking History")),
      body: FutureBuilder<List<BookingHistory>>(
        future: bookingHistory,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No bookings found.'));
          } else {
            List<BookingHistory> bookings = snapshot.data!;
            return ListView.builder(
              itemCount: bookings.length,
              itemBuilder: (context, index) {
                final booking = bookings[index];
                return ListTile(
                  title: Text('Booking ID: ${booking.bookingId}'),
                  subtitle: Text('Spot ID: ${booking.spotId}\nBooking Date: ${booking.bookingDate}\nAmount: ${booking.amount}'),
                  isThreeLine: true,
                );
              },
            );
          }
        },
      ),
    );
  }
}
