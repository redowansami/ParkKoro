# controllers/review_controller.py
from flask import request, jsonify
from models.booking_model import Booking
from models.review_model import Review
from models.parking_spot_model import ParkingSpot
from models.user_model import User
from __init__ import db

# Function for adding a review
def add_review(spot_id):
    data = request.get_json()

    # Get data from request
    username = data.get('username')
    rating_score = data.get('rating_score')
    review_text = data.get('review_text')

    if not username or not rating_score or not review_text:
        return jsonify({'message': 'Username, Rating score, and Review text are required'}), 400

    # # Check if the user has booked the parking spot (assuming the booking system is set)
    # booking = Booking.query.filter_by(renter_id=username, spot_id=spot_id).first()
    # if not booking:
    #     return jsonify({'message': 'You have not booked this parking spot'}), 403

    # Create a new review object
    review = Review(
        user_id=username,
        spot_id=spot_id,
        rating_score=rating_score,
        review_text=review_text
    )

    db.session.add(review)
    db.session.commit()

    return jsonify({'message': 'Review added successfully'}), 201

def view_all_reviews():
    reviews = Review.query.all()  # Fetch all reviews from the Review table
    if not reviews:
        return jsonify({'message': 'No reviews available'}), 404

    reviews_list = [{
        'review_id': review.review_id,
        'user_id': review.user_id,
        'username': review.user.username,
        'rating_score': review.rating_score,
        'review_text': review.review_text,
        'timestamp': review.timestamp
    } for review in reviews]

    return jsonify(reviews_list), 200


# Function for viewing reviews of a parking spot
def view_reviews(spot_id):
    reviews = Review.query.filter_by(spot_id=spot_id).all()
    if not reviews:
        return jsonify({'message': 'No reviews for this parking spot'}), 404

    reviews_list = [{
        'review_id': review.review_id,
        'user_id': review.user_id,
        'username': review.user.username,
        'rating_score': review.rating_score,
        'review_text': review.review_text,
        'timestamp': review.timestamp
    } for review in reviews]

    return jsonify(reviews_list), 200

def delete_review(review_id):
    # Find the review by review_id
    review = Review.query.filter_by(review_id=review_id).first()
    
    if not review:
        return jsonify({'message': 'Review not found'}), 404

    # Delete the review
    db.session.delete(review)
    db.session.commit()

    return jsonify({'message': 'Review deleted successfully'}), 200


def view_booked_spot():
    data = request.get_json()

    # Get the username from request
    username = data.get('username')

    if not username:
        return jsonify({'message': 'Username is required'}), 400

    # Fetch the user by username
    user = User.query.filter_by(username=username).first()
    if not user:
        return jsonify({'message': 'User not found'}), 404

    # Query the Booking table to find all the parking spots booked by the user (renter_id)
    bookings = Booking.query.filter_by(renter_id=username).all()

    if not bookings:
        return jsonify({'message': 'No bookings found for this user'}), 404

    spots_details = []

    # For each booking, fetch the associated parking spot details
    for booking in bookings:
        parking_spot = ParkingSpot.query.filter_by(spot_id=booking.spot_id, verified=True).first()

        if parking_spot:
            spot_details = {
                'spot_id': parking_spot.spot_id,
                'location': parking_spot.location,
                'owner': parking_spot.owner_id,
                'price_per_hour': parking_spot.price,
                'available': parking_spot.availability_status,

            }
            spots_details.append(spot_details)

    return jsonify(spots_details), 200