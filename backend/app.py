from flask_cors import CORS
from flask import Flask, request, jsonify
from flask_jwt_extended import JWTManager, create_access_token, jwt_required, get_jwt_identity
from flask_login import LoginManager, login_user, logout_user, login_required, current_user  # Import Flask-Login components
from models.user_model import User
from models.parking_spot_model import ParkingSpot
from models.parking_spot_model import ParkingSpot as ParkingSpotModel
from models.brta_data_model import BrtaData
from controllers.auth_controller import register, login
from controllers.parking_controller import add_parking_spot, unverified_parking_spots, review_parking_spot, verified_parking_spots
from __init__ import db, bcrypt, jwt, create_app, login_manager  # Import login_manager
from datetime import timedelta
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker, scoped_session

# Create the Flask app
app = create_app()

# Initialize BRTA database session
brta_engine = create_engine(app.config['SQLALCHEMY_BINDS']['brta'], echo=True)
BrtaSession = sessionmaker(bind=brta_engine)
brta_session = scoped_session(BrtaSession)

# Initialize database
@app.before_request
def create_tables():
    pass

# Routes
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
@login_required  # Protect the route with login_required
def logout_route():
    logout_user()  # Log out the user using Flask-Login
    return jsonify({'message': 'Logged out successfully'}), 200


@app.route('/add_parking_spot', methods=['POST'])  # Ensure POST is allowed
def add_parking_spot():
    try:
        data = request.get_json()
        print('Received payload:', data)  # Debugging

        # Validate required fields
        required_fields = ['spot_id', 'owner_id', 'vehicle_type', 'location', 'gps_coordinates', 'price']
        for field in required_fields:
            if field not in data:
                return jsonify({'message': f'Missing required field: {field}'}), 400

        # Create a new parking spot
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

@app.route('/unverified_parking_spots', methods=['GET'])
def unverified_parking_spots_route():
    try:
        # Fetch unverified parking spots from the database
        unverified_spots = ParkingSpot.query.filter_by(verified=False).all()

        # Convert the list of ParkingSpot objects to a list of dictionaries
        spots_list = [{
            'id': spot.id,
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

        # Return the list as a JSON response
        return jsonify(spots_list), 200
    except Exception as e:
        return jsonify({'message': 'An error occurred', 'error': str(e)}), 500

@app.route('/review_parking_spot/<int:spot_id>', methods=['POST'])
def review_parking_spot(spot_id):
    try:
        data = request.get_json()
        action = data.get('action')  # Ensure this is "accept" or "delete"

        # Fetch the parking spot by ID
        spot = ParkingSpot.query.get(spot_id)
        if not spot:
            return jsonify({'message': 'Parking spot not found.'}), 404

        if action == 'accept':
            # Mark the spot as verified
            spot.verified = True  # Update the verified field
            db.session.commit()
            return jsonify({'message': 'Parking spot approved.'}), 200

        elif action == 'delete':
            # Delete the spot from the database
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

if __name__ == '__main__':
    app.run(debug=True, host="127.0.0.1", port=5000)