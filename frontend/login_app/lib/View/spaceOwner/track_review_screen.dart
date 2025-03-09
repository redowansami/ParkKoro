import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TrackReviewsScreen extends StatefulWidget {
  final String ownerId;

  const TrackReviewsScreen({required this.ownerId, Key? key}) : super(key: key);

  @override
  _TrackReviewsScreenState createState() => _TrackReviewsScreenState();
}

class _TrackReviewsScreenState extends State<TrackReviewsScreen> {
  late Future<List<ParkingSpot>> parkingSpots;

  @override
  void initState() {
    super.initState();
    parkingSpots = fetchParkingSpots(widget.ownerId);
  }

  Future<List<ParkingSpot>> fetchParkingSpots(String ownerId) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:5000/get_parking_spots'),
      headers: <String, String>{'Content-Type': 'application/json'},
      body: json.encode({'owner_id': ownerId}),
    );

    if (response.statusCode == 200) {
      final List<dynamic> spotsList = json.decode(response.body);
      return spotsList.map((data) => ParkingSpot.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load parking spots');
    }
  }

  Future<List<Review>> fetchReviews(int spotId) async {
    final response = await http.get(
      Uri.parse('http://10.0.2.2:5000/reviews/parking_spot/$spotId'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> reviewList = json.decode(response.body);
      return reviewList.map((data) => Review.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load reviews');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E3A8A),
        title: const Text(
          'Track Reviews for Your Parking Spots',
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
        child: FutureBuilder<List<ParkingSpot>>(
          future: parkingSpots,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator(color: Colors.white));
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}', style: const TextStyle(color: Colors.white)));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No parking spots available.', style: TextStyle(color: Colors.white)));
            } else {
              final spots = snapshot.data!;
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: spots.length,
                itemBuilder: (context, index) {
                  final spot = spots[index];
                  return Card(
                    color: Colors.white.withOpacity(0.9),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 3,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ExpansionTile(
                      title: Text(
                        spot.location,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text('Price: \$${spot.price} per hour'),
                      children: [
                        FutureBuilder<List<Review>>(
                          future: fetchReviews(spot.spotId),
                          builder: (context, reviewSnapshot) {
                            if (reviewSnapshot.connectionState == ConnectionState.waiting) {
                              return const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: CircularProgressIndicator(),
                              );
                            } else if (reviewSnapshot.hasError) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('Error loading reviews: ${reviewSnapshot.error}'),
                              );
                            } else if (!reviewSnapshot.hasData || reviewSnapshot.data!.isEmpty) {
                              return const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('No reviews yet for this parking spot.'),
                              );
                            } else {
                              final reviews = reviewSnapshot.data!;
                              return ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: reviews.length,
                                itemBuilder: (context, index) {
                                  final review = reviews[index];
                                  return ListTile(
                                    title: Text(
                                      '${review.username} - Rating: ${review.ratingScore}',
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    subtitle: Text(review.reviewText),
                                  );
                                },
                              );
                            }
                          },
                        ),
                      ],
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

class ParkingSpot {
  final int spotId;
  final String location;
  final double price;
  final String vehicleType;
  final bool evCharging;
  final bool surveillance;
  final String cancellationPolicy;
  final bool availabilityStatus;

  ParkingSpot({
    required this.spotId,
    required this.location,
    required this.price,
    required this.vehicleType,
    required this.evCharging,
    required this.surveillance,
    required this.cancellationPolicy,
    required this.availabilityStatus,
  });

  factory ParkingSpot.fromJson(Map<String, dynamic> json) {
    return ParkingSpot(
      spotId: json['spot_id'],
      location: json['location'],
      price: json['price'].toDouble(),
      vehicleType: json['vehicle_type'],
      evCharging: json['ev_charging'],
      surveillance: json['surveillance'],
      cancellationPolicy: json['cancellation_policy'],
      availabilityStatus: json['availability_status'],
    );
  }
}

class Review {
  final int reviewId;
  final String username;
  final int ratingScore;
  final String reviewText;
  final String timestamp;

  Review({
    required this.reviewId,
    required this.username,
    required this.ratingScore,
    required this.reviewText,
    required this.timestamp,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      reviewId: json['review_id'],
      username: json['username'],
      ratingScore: json['rating_score'],
      reviewText: json['review_text'],
      timestamp: json['timestamp'],
    );
  }
}