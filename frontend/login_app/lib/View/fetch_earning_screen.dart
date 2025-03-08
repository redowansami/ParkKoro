import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BookingEarnings {
  final String bookingId;
  final int spotId;
  final String bookingDate;
  final String amount;

  BookingEarnings({
    required this.bookingId,
    required this.spotId,
    required this.bookingDate,
    required this.amount,
  });

  factory BookingEarnings.fromJson(Map<String, dynamic> json) {
    return BookingEarnings(
      bookingId: json['booking_id'],
      spotId: json['spot_id'],
      bookingDate: json['booking_date'],
      amount: json['amount'],  // The amount from the Payment table
    );
  }
}

class FetchEarningsScreen extends StatefulWidget {
  final String ownerId;  // Pass owner_id when navigating

  FetchEarningsScreen({required this.ownerId});

  @override
  _FetchEarningsScreenState createState() => _FetchEarningsScreenState();
}

class _FetchEarningsScreenState extends State<FetchEarningsScreen> {
  late Future<List<BookingEarnings>> earnings;

  Future<List<BookingEarnings>> fetchEarnings(String ownerId) async {
    final response = await http.get(Uri.parse('http://10.0.2.2:5000/fetch_earnings/$ownerId'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((earning) => BookingEarnings.fromJson(earning)).toList();
    } else {
      throw Exception('Failed to load earnings');
    }
  }

  @override
  void initState() {
    super.initState();
    earnings = fetchEarnings(widget.ownerId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Earnings")),
      body: FutureBuilder<List<BookingEarnings>>(
        future: earnings,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No earnings found.'));
          } else {
            List<BookingEarnings> earningsList = snapshot.data!;
            return ListView.builder(
              itemCount: earningsList.length,
              itemBuilder: (context, index) {
                final earning = earningsList[index];
                return ListTile(
                  title: Text('Booking ID: ${earning.bookingId}'),
                  subtitle: Text('Spot ID: ${earning.spotId}\nBooking Date: ${earning.bookingDate}\nAmount: ${earning.amount}'),
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