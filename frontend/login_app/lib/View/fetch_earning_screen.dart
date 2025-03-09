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
      amount: json['amount'], // The amount from the Payment table
    );
  }
}

class FetchEarningsScreen extends StatefulWidget {
  final String ownerId; // Pass owner_id when navigating

  const FetchEarningsScreen({required this.ownerId, Key? key}) : super(key: key);

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
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E3A8A),
        title: const Text(
          'Earnings',
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
        child: FutureBuilder<List<BookingEarnings>>(
          future: earnings,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.white),
              );
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
                  'No earnings found.',
                  style: TextStyle(color: Colors.white),
                ),
              );
            } else {
              List<BookingEarnings> earningsList = snapshot.data!;
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: earningsList.length,
                itemBuilder: (context, index) {
                  final earning = earningsList[index];
                  return Card(
                    color: Colors.white.withOpacity(0.9),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 3,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text(
                        'Booking ID: ${earning.bookingId}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        'Spot ID: ${earning.spotId}\nBooking Date: ${earning.bookingDate}\nAmount: ${earning.amount}',
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