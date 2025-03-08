import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddReviewScreen extends StatefulWidget {
  final String username;

  AddReviewScreen({required this.username});

  @override
  _AddReviewScreenState createState() => _AddReviewScreenState();
}

class _AddReviewScreenState extends State<AddReviewScreen> {
  late Future<List<ParkingSpotTemp>> bookedSpots;
  int? selectedRating;

  @override
  void initState() {
    super.initState();
    bookedSpots = fetchBookedSpots(widget.username);
  }

  // Fetch the booked parking spots for the user
  Future<List<ParkingSpotTemp>> fetchBookedSpots(String username) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2.:5000/booked_spot'),
      headers: <String, String>{'Content-Type': 'application/json'},
      body: json.encode({'username': username}),
    );

    if (response.statusCode == 200) {
      final List<dynamic> spotsList = json.decode(response.body);
      return spotsList.map((data) => ParkingSpotTemp.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load booked spots');
    }
  }

  // Function to handle review addition
  Future<void> addReview(int spotId) async {
    final _reviewController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Review'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Dropdown for rating selection
              DropdownButton<int>(
                hint: Text('Select Rating (1-5)'),
                value: selectedRating,
                onChanged: (int? newValue) {
                  setState(() {
                    selectedRating = newValue;
                  });
                },
                items: [1, 2, 3, 4, 5]
                    .map<DropdownMenuItem<int>>((int value) {
                  return DropdownMenuItem<int>(
                    value: value,
                    child: Text(value.toString()),
                  );
                }).toList(),
              ),
              TextField(
                controller: _reviewController,
                decoration: InputDecoration(labelText: 'Review Text'),
                keyboardType: TextInputType.text,
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                final rating = selectedRating;
                final reviewText = _reviewController.text;

                if (rating != null && reviewText.isNotEmpty) {
                  final response = await http.post(
                    Uri.parse('http://10.0.2.2.:5000/reviews/parking_spot/$spotId/add'),
                    headers: <String, String>{'Content-Type': 'application/json'},
                    body: json.encode({
                      'username': widget.username,
                      'rating_score': rating,
                      'review_text': reviewText,
                    }),
                  );

                  if (response.statusCode == 201) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Review added successfully!')),
                    );
                    Navigator.pop(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to add review')),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please provide valid input')),
                  );
                }
              },
              child: Text('Submit'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Track Booked Spots and Add Reviews'),
      ),
      body: FutureBuilder<List<ParkingSpotTemp>>(
        future: bookedSpots,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No booked spots available.'));
          } else {
            final spots = snapshot.data!;
            return ListView.builder(
              itemCount: spots.length,
              itemBuilder: (context, index) {
                final spot = spots[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  child: ListTile(
                    title: Text('Spot: ${spot.location}'),
                    subtitle: Text('Price per hour: \$${spot.pricePerHour}'),
                    trailing: ElevatedButton(
                      onPressed: () {
                        addReview(spot.spotId); // Trigger the add review dialog
                      },
                      child: Text('Add Review'),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

// Model for Parking Spot
class ParkingSpotTemp {
  final int spotId;
  final String location;
  final double pricePerHour;

  ParkingSpotTemp({
    required this.spotId,
    required this.location,
    required this.pricePerHour,
  });

  factory ParkingSpotTemp.fromJson(Map<String, dynamic> json) {
    return ParkingSpotTemp(
      spotId: json['spot_id'],
      location: json['location'],
      pricePerHour: json['price_per_hour'].toDouble(),
    );
  }
}
