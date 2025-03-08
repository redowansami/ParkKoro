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
    final response = await http.get(Uri.parse('http://10.0.2.2:5000/view_all_reviews'));

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Reviews'),
      ),
      body: FutureBuilder<List<Review>>(
        future: reviews,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No reviews available.'));
          } else {
            final reviews = snapshot.data!;
            return ListView.builder(
              itemCount: reviews.length,
              itemBuilder: (context, index) {
                final review = reviews[index];
                return ListTile(
                  title: Text('${review.username} - Rating: ${review.ratingScore}'),
                  subtitle: Text(review.reviewText),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => deleteReview(review.reviewId),
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
