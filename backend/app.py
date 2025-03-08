from flask_cors import CORS
from flask import Flask, request, jsonify
from flask_jwt_extended import JWTManager, create_access_token, jwt_required, get_jwt_identity
from flask_login import LoginManager, login_user, logout_user, login_required, current_user  # Import Flask-Login components
from controllers.review_controller import add_review, delete_review, view_all_reviews, view_booked_spot, view_reviews
from controllers.notification_controller import send_notification, view_notifications
from models.user_model import User
from models.parking_spot_model import ParkingSpot
from models.parking_spot_model import ParkingSpot as ParkingSpotModel
from models.brta_data_model import BrtaData
from controllers.payment_controller import process_payment, initiate_refund, get_payment_details
from controllers.booking_controller import create_booking, cancel_booking, view_booking_details, update_availability
from controllers.auth_controller import edit_password, register, login
from controllers.parking_controller import add_parking_spot, edit_parking_spot, get_parking_spots_by_owner, search_nearest_parking_spots, unverified_parking_spots, review_parking_spot, verified_parking_spots
from __init__ import db, bcrypt, jwt, create_app, login_manager  # Import login_manager
from datetime import timedelta
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker, scoped_session

app = create_app()

brta_engine = create_engine(app.config['SQLALCHEMY_BINDS']['brta'], echo=True)
BrtaSession = sessionmaker(bind=brta_engine)
brta_session = scoped_session(BrtaSession)

@app.before_request
def create_tables():
    pass

@app.route('/', methods=['GET'])
def home():
    return "Backend is working with a single ParkingSpot table!"

@app.route('/register', methods=['POST'])
def register_route():
    return register()

@app.route('/login', methods=['POST'])
def login_route():
    return login()

@app.route('/logout', methods=['POST'])
@login_required  
def logout_route():
    logout_user() 
    return jsonify({'message': 'Logged out successfully'}), 200

# In app.py or auth_controller.py
@app.route('/edit_password', methods=['PUT'])
def edit_password_route():
    return edit_password()

@app.route('/update_profile', methods=['PUT'])
def update_profile():
    """Allows the logged-in user to update profile information."""
    data = request.get_json()

    # Extract user data
    username = data.get('username')
    nid = data.get('nid')
    email = data.get('email')
    phone = data.get('phone')

    if not username or not nid or not email or not phone:
        return jsonify({'message': 'All fields are required'}), 400

    # Fetch user from the database
    user = User.query.filter_by(username=username).first()
    if not user:
        return jsonify({'message': 'User not found'}), 404

    # Update user profile information
    user.nid = nid
    user.email = email
    user.phone = phone
    db.session.commit()

    return jsonify({'message': 'Profile updated successfully'}), 200

@app.route('/get_profile_info', methods=['POST'])
def get_profile_info():
    """Fetch the profile information of a user based on the provided username."""
    data = request.get_json()

    # Get the username from the request body
    username = data.get('username')

    if not username:
        return jsonify({'message': 'Username is required'}), 400

    # Query the user from the database using the username
    user = User.query.filter_by(username=username).first()

    # Check if the user exists
    if not user:
        return jsonify({'message': 'User not found'}), 404

    # If NID is null, return a message or leave it empty
    nid = user.nid if user.nid else 'NID not available'

    # Return the user's profile information
    profile_info = {
        'nid': nid,
        'email': user.email,
        'phone': user.phone,
    }

    return jsonify(profile_info), 200

@app.route('/add_parking_spot', methods=['POST']) 
def add_parking_route():
    return add_parking_spot()

@app.route('/search_nearest_parking_spots', methods=['POST'])
def search_nearest_parking_spots_route():
    return search_nearest_parking_spots()


@app.route('/get_parking_spots', methods=['POST'])
def get_parking_spots_route():
    return get_parking_spots_by_owner()

@app.route('/edit_parking_spot', methods=['PUT'])
def edit_parking_spot_route():
    return edit_parking_spot()

@app.route('/unverified_parking_spots', methods=['GET'])
def unverified_parking_routes():
    return unverified_parking_spots()

@app.route('/admin/parking_spots/<spot_id>', methods=['DELETE'])
def delete_parking_spot(spot_id):
    """Delete a parking spot by ID"""
    spot = ParkingSpot.query.get(spot_id)
    if not spot:
        return jsonify({'message': 'Parking spot not found'}), 404

    db.session.delete(spot)
    db.session.commit()
    return jsonify({'message': 'Parking spot deleted successfully'}), 200

@app.route('/review_parking_spot/<spot_id>', methods=['POST'])  # spot_id is now a string
def review_parking_spot_route(spot_id):
    return review_parking_spot(spot_id)
    
@app.route('/verified_parking_spots', methods=['GET'])
def verified_parking_spots_route():
    return verified_parking_spots()

@app.route('/brta', methods=['GET'])
def brta_route():
    nid = request.args.get('nid')
    if not nid:
        return jsonify({'message': 'NID is required'}), 400

    if not callable(BrtaSession):
        return jsonify({'message': 'BrtaSession is not callable. Check initialization.'}), 500

    try:
        brta_record = brta_session.query(BrtaData).filter_by(nid=nid).first()
        if brta_record:
            return jsonify({
                'email': brta_record.email,
                'phone_number': brta_record.phone_number,
                'car_type': brta_record.car_type,
                'license_plate_number': brta_record.license_plate_number,
                'driving_license_number': brta_record.driving_license_number
            }), 200
        else:
            return jsonify({'message': 'Data not found for the provided NID'}), 404
    except Exception as e:
        return jsonify({'message': 'An error occurred', 'error': str(e)}), 500
    finally:
        brta_session.remove()


#admin
@app.route('/admin/users', methods=['GET'])
def get_all_users():
    """Fetch all users from the database"""
    users = User.query.all()
    users_list = [{
        'id': user.id,
        'username': user.username,
        'email': user.email,
        'phone': user.phone,
        'user_type': user.user_type
    } for user in users]
    
    return jsonify(users_list), 200

@app.route('/admin/users/<int:user_id>', methods=['DELETE'])
def delete_user(user_id):
    """Delete a user by ID"""
    user = User.query.get(user_id)
    if not user:
        return jsonify({'message': 'User not found'}), 404

    db.session.delete(user)
    db.session.commit()
    return jsonify({'message': 'User deleted successfully'}), 200


#booking routes

@app.route('/api/bookings', methods=['POST'])
def create_booking_route():
    return create_booking()

@app.route('/api/bookings/<booking_id>/cancel', methods=['PUT'])
def cancel_booking_route(booking_id):
    return cancel_booking(booking_id)

@app.route('/api/bookings/<booking_id>', methods=['GET'])
def view_booking_details_route(booking_id):
    return view_booking_details(booking_id)

@app.route('/api/parking_spots/<spot_id>/availability', methods=['PUT'])
def update_availability_route(spot_id):
    return update_availability(spot_id)

#payment controller

@app.route('/api/payments', methods=['POST'])
def process_payment_route():
    return process_payment()

@app.route('/api/payments/<transaction_id>/refund', methods=['PUT'])
def initiate_refund_route(transaction_id):
    return initiate_refund(transaction_id)

@app.route('/api/payments/<transaction_id>', methods=['GET'])
def get_payment_details_route(transaction_id):
    return get_payment_details(transaction_id)

@app.route('/notifications/send', methods=['POST'])
def send_notification_route():
    return send_notification()

@app.route('/notifications/view', methods=['GET'])
def view_notifications_route():
    return view_notifications()

# @app.route('/api/payments/sslcommerz', methods=['POST'])
# def process_sslcommerz_payment():
#     data = request.get_json()
#     required_fields = ['booking_id', 'amount','vehicle_owner']
#     print(data)
#     if not all(field in data for field in required_fields):
#         return jsonify({'message': 'Missing required fields.'}), 400

#     # Here you would invoke the SSLCommerz API, and handle payment processing logic.
#     # Use the data['booking_id'] and data['amount'] to trigger the payment process
#     # Simulating payment success
#     payment_successful, transaction_id = process_sslcommerz_payment_logic(data['amount'],data['booking_id'],data['vehicle_owner'])

#     if not payment_successful:
#         return jsonify({'message': 'Payment failed. Booking not created.'}), 400

#     # Now that payment is successful, we update the booking and add payment record
#     booking = Booking.query.filter_by(booking_id=data['booking_id']).first()
#     if not booking:
#         return jsonify({'message': 'Booking not found.'}), 404

#     new_payment = Payment(
#         transaction_id=transaction_id,
#         amount=data['amount'],
#         status='Completed',
#         booking_id=data['booking_id'],
#         refund_status='Pending'
#     )
#     db.session.add(new_payment)
#     db.session.commit()

#     booking.cancellation_status = 'Confirmed'
#     db.session.commit()

#     return jsonify({'message': 'Booking confirmed after successful payment.'}), 201

#review routes
@app.route('/reviews/parking_spot/<int:spot_id>/add', methods=['POST'])
def add_review_route(spot_id):
    return add_review(spot_id)

# View all reviews for a parking spot (admin or anyone else)
@app.route('/reviews/parking_spot/<int:spot_id>', methods=['GET'])
def view_reviews_route(spot_id):
    return view_reviews(spot_id)

@app.route('/booked_spot', methods=['POST'])
def view_booked_spot_route():
    return view_booked_spot()

@app.route('/view_all_reviews', methods=['GET'])
def view_all_reviews_route():
    return view_all_reviews()

@app.route('/reviews/delete/<int:review_id>', methods=['DELETE'])
def delete_review_route(review_id):
    return delete_review(review_id)

if __name__ == '__main__':
    app.run(debug=True, host="0.0.0.0", port=5000)