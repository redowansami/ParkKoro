from flask_cors import CORS
from flask import Flask, request, jsonify
from flask_jwt_extended import JWTManager, create_access_token, jwt_required, get_jwt_identity
from flask_login import LoginManager, login_user, logout_user, login_required, current_user  # Import Flask-Login components
from controllers.notification_controller import send_notification, view_notifications
from models.user_model import User
from models.parking_spot_model import ParkingSpot
from models.parking_spot_model import ParkingSpot as ParkingSpotModel
from models.brta_data_model import BrtaData
from controllers.payment_controller import process_payment, initiate_refund, get_payment_details
from controllers.booking_controller import create_booking, cancel_booking, view_booking_details, update_availability
from controllers.auth_controller import register, login
from controllers.parking_controller import add_parking_spot, edit_parking_spot, get_parking_spots_by_owner, unverified_parking_spots, review_parking_spot, verified_parking_spots
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
@jwt_required()
def edit_password():
    # Get the current user from the JWT token
    current_user_data = get_jwt_identity()
    username = current_user_data['username']

    # Fetch the user from the database
    user = User.query.filter_by(username=username).first()

    if not user:
        return jsonify({'message': 'User not found'}), 404

    # Get the data from the request
    data = request.get_json()
    new_password = data.get('new_password')
    current_password = data.get('current_password')

    if not new_password or not current_password:
        return jsonify({'message': 'Both current and new passwords are required'}), 400

    # Verify the current password
    if not bcrypt.check_password_hash(user.password, current_password):
        return jsonify({'message': 'Current password is incorrect'}), 400

    # Hash the new password and update it
    hashed_new_password = bcrypt.generate_password_hash(new_password).decode('utf-8')
    user.password = hashed_new_password

    # Save the updated password
    db.session.commit()

    return jsonify({'message': 'Password updated successfully'}), 200


@app.route('/add_parking_spot', methods=['POST']) 
def add_parking_spot():
    try:
        data = request.get_json()
        print('Received payload:', data)  

        required_fields = ['spot_id', 'owner_id', 'vehicle_type', 'location', 'gps_coordinates', 'price']
        for field in required_fields:
            if field not in data:
                return jsonify({'message': f'Missing required field: {field}'}), 400

        new_spot = ParkingSpotModel(
            spot_id=data['spot_id'],
            owner_id=data['owner_id'],
            admin_id=data.get('admin_id'),
            vehicle_type=data['vehicle_type'],
            location=data['location'],
            gps_coordinates=data['gps_coordinates'],
            price=data['price'],
            ev_charging=data.get('ev_charging', False),
            surveillance=data.get('surveillance', False),
            cancellation_policy=data.get('cancellation_policy', 'Strict'),
            availability_status=data.get('availability_status', True)
        )
        db.session.add(new_spot)
        db.session.commit()

        return jsonify({'message': 'Parking spot submitted for review.'}), 201
    except Exception as e:
        print('Error:', str(e))  # Debugging
        return jsonify({'message': 'An error occurred', 'error': str(e)}), 500

@app.route('/get_parking_spots', methods=['POST'])
def get_parking_spots_route():
    return get_parking_spots_by_owner()

@app.route('/edit_parking_spot', methods=['PUT'])
def edit_parking_spot_route():
    return edit_parking_spot()

@app.route('/unverified_parking_spots', methods=['GET'])
def unverified_parking_spots():
    unverified_spots = ParkingSpot.query.filter_by(verified=False).all()
    spots_list = [{
        'spot_id': spot.spot_id,
        'owner_id': spot.owner_id,
        'admin_id': spot.admin_id,
        'vehicle_type': spot.vehicle_type,
        'location': spot.location,
        'gps_coordinates': spot.gps_coordinates,
        'price': spot.price,
        'ev_charging': spot.ev_charging,
        'surveillance': spot.surveillance,
        'cancellation_policy': spot.cancellation_policy,
        'availability_status': spot.availability_status
    } for spot in unverified_spots]
    return jsonify(spots_list), 200

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
def review_parking_spot(spot_id):
    try:
        data = request.get_json()
        action = data.get('action')
       
        # Query the ParkingSpot by the spot_id (string)
        spot = ParkingSpot.query.filter_by(spot_id=spot_id).first()  # Use filter_by since spot_id is a string now
        if not spot:
            return jsonify({'message': 'Parking spot not found.'}), 404

        if action == 'accept':
            spot.verified = True  
            db.session.commit()
            return jsonify({'message': 'Parking spot approved.'}), 200

        elif action == 'delete':
            db.session.delete(spot)
            db.session.commit()
            return jsonify({'message': 'Parking spot deleted.'}), 200

        else:
            return jsonify({'message': 'Invalid action.'}), 400

    except Exception as e:
        return jsonify({'message': 'An error occurred', 'error': str(e)}), 500
    
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

if __name__ == '__main__':
    app.run(debug=True, host="127.0.0.1", port=5000)