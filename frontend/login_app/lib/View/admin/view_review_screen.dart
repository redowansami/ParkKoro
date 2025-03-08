import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ViewReviewsScreen extends StatefulWidget {
  @override
  _ViewReviewsScreenState createState() => _ViewReviewsScreenState();
}

class _ViewReviewsScreenState extends State<ViewReviewsScreen> {
  late Future<List<Review>> reviews;

  @override
  void initState() {
    super.initState();
    reviews = fetchReviews();
  }

  Future<List<Review>> fetchReviews() async {
    final response = await http.get(Uri.parse('http://192.168.1.106:5000/view_all_reviews'));

    if (response.statusCode == 200) {
      final List<dynamic> reviewList = json.decode(response.body);
      return reviewList.map((data) => Review.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load reviews');
    }
  }

  Future<void> deleteReview(int reviewId) async {
    final response = await http.delete(
      Uri.parse('http://10.0.2.2:5000/reviews/delete/$reviewId'),
    );

    if (response.statusCode == 200) {
      setState(() {
        reviews = fetchReviews(); // Refresh the reviews after deletion
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Review deleted successfully')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to delete review')));
    }
  }

  // Show confirmation dialog before deleting review
  void _showDeleteConfirmation(int reviewId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const Text('Are you sure you want to delete this review?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                deleteReview(reviewId); // Proceed with deletion
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
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
        backgroundColor: const Color(0xFF1E3A8A), // Same color theme as previous screens
        title: const Text(
          'All Reviews',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.5,
          ),
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
        child: FutureBuilder<List<Review>>(
          future: reviews,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No reviews available.'));
            } else {
              final reviews = snapshot.data!;
              return ListView.builder(
                itemCount: reviews.length,
                itemBuilder: (context, index) {
                  final review = reviews[index];
                  return Card(
                    color: Colors.white.withOpacity(0.8), // Slight opacity for cards
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      title: Text(
                        '${review.username} - Rating: ${review.ratingScore}',
                        style: const TextStyle(
                          color: Color(0xFF1E3A8A), // Dark blue color for title
                        ),
                      ),
                      subtitle: Text(
                        review.reviewText,
                        style: const TextStyle(
                          color: Colors.black87,
                        ),
                      ),
                      trailing: IconButton(
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                        onPressed: () => _showDeleteConfirmation(review.reviewId), // Show confirmation before deletion
                      ),
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

class Review {
  final int reviewId;
  final String username;
  final String reviewText;
  final int ratingScore;

  Review({
    required this.reviewId,
    required this.username,
    required this.reviewText,
    required this.ratingScore,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      reviewId: json['review_id'],
      username: json['username'],
      reviewText: json['review_text'],
      ratingScore: json['rating_score'],
    );
  }
}
