# from flask import Flask, request, jsonify
# from flask_sqlalchemy import SQLAlchemy
# from flask_bcrypt import Bcrypt
# from flask_jwt_extended import JWTManager, create_access_token
# from flask_cors import CORS
# from sqlalchemy import create_engine
# from sqlalchemy.orm import sessionmaker
# from datetime import timedelta

# app = Flask(__name__)
# CORS(app)

# # Configuration for the main app database (mydb)
# app.config['SQLALCHEMY_DATABASE_URI'] = 'postgresql://sami:sami@localhost/mydb'
# app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
# app.config['JWT_SECRET_KEY'] = 'your_jwt_secret_key'

# # Configuration for the BRTA database (read-only)
# app.config['SQLALCHEMY_BINDS'] = {
#     'brta': 'postgresql://sami:sami@localhost/brta'
# }

# db = SQLAlchemy(app)
# bcrypt = Bcrypt(app)
# jwt = JWTManager(app)

# # Configuration for the BRTA database (read-only)
# brta_engine = create_engine('postgresql://sami:sami@localhost/brta', echo=True)
# BrtaSession = sessionmaker(bind=brta_engine)
# brta_session = BrtaSession()

# # User model for mydb
# class User(db.Model):
#     id = db.Column(db.Integer, primary_key=True)
#     username = db.Column(db.String(80), unique=True, nullable=False)
#     password = db.Column(db.String(200), nullable=False)
#     user_type = db.Column(db.String(50), nullable=False)  # VehicleOwner, SpaceOwner, Admin
#     nid = db.Column(db.String(20), unique=True, nullable=True)  # Optional, used for VehicleOwner
#     email = db.Column(db.String(120), nullable=False)
#     phone = db.Column(db.String(20), nullable=False)
#     car_type = db.Column(db.String(50), nullable=True)  # Only for VehicleOwner
#     license_plate_number = db.Column(db.String(50), nullable=True)  # Only for VehicleOwner
#     driving_license_number = db.Column(db.String(50), nullable=True)  # Only for VehicleOwner

# # Model for BRTA data (read-only)
# class BrtaData(db.Model):
#     __tablename__ = 'brta_data'
#     __bind_key__ = 'brta'  # This tells SQLAlchemy this model is for the BRTA database

#     # Set nid as the primary key since there's no 'id' column
#     nid = db.Column(db.String(20), unique=True, primary_key=True)
#     email = db.Column(db.String(120), nullable=False)
#     phone_number = db.Column(db.String(20), nullable=False)
#     car_type = db.Column(db.String(50), nullable=False)
#     license_plate_number = db.Column(db.String(50), nullable=False)
#     driving_license_number = db.Column(db.String(50), nullable=False)

# # Parking Spots Model
# class ParkingSpot(db.Model):
#     id = db.Column(db.Integer, primary_key=True)
#     spot_id = db.Column(db.String(50), nullable=False)
#     gps_coordinates = db.Column(db.String(100), nullable=False)
#     address = db.Column(db.String(255), nullable=False)
#     pricing = db.Column(db.Float, nullable=False)
#     availability_status = db.Column(db.Boolean, default=True)
#     ev_charging_availability = db.Column(db.Boolean, default=False)
#     surveillance_availability = db.Column(db.Boolean, default=False)
#     verified = db.Column(db.Boolean, default=False)  # True if approved by admin, False otherwise

# # Initialize database
# @app.before_request
# def create_tables():
#     db.create_all()

# # Test Route
# @app.route('/', methods=['GET'])
# def home():
#     return "Backend is working with a single ParkingSpot table!"

# # Registration route
# @app.route('/register', methods=['POST'])
# def register():
#     data = request.get_json()
#     username = data.get('username')
#     password = data.get('password')
#     user_type = data.get('user_type')
#     nid = data.get('nid')
#     email = data.get('email')
#     phone = data.get('phone')
#     car_type = data.get('car_type')
#     license_plate_number = data.get('license_plate_number')
#     driving_license_number = data.get('driving_license_number')

#     if not username or not password or not user_type or not email or not phone:
#         return jsonify({'message': 'Missing required fields'}), 400

#     if user_type == 'VehicleOwner' and not nid:
#         return jsonify({'message': 'NID is required for VehicleOwner'}), 400

#     if User.query.filter_by(username=username).first():
#         return jsonify({'message': 'Username already exists'}), 400

#     hashed_password = bcrypt.generate_password_hash(password).decode('utf-8')
#     new_user = User(
#         username=username,
#         password=hashed_password,
#         user_type=user_type,
#         nid=nid,
#         email=email,
#         phone=phone,
#         car_type=car_type if user_type == 'VehicleOwner' else None,
#         license_plate_number=license_plate_number if user_type == 'VehicleOwner' else None,
#         driving_license_number=driving_license_number if user_type == 'VehicleOwner' else None
#     )
#     db.session.add(new_user)
#     db.session.commit()

#     return jsonify({'message': 'User registered successfully'}), 201

# # Login route
# @app.route('/login', methods=['POST'])
# def login():
#     data = request.get_json()
#     username = data.get('username')
#     password = data.get('password')

#     user = User.query.filter_by(username=username).first()
#     if user and bcrypt.check_password_hash(user.password, password):
#         access_token = create_access_token(
#             identity={
#                 'username': user.username,
#                 'user_type': user.user_type
#             },
#             expires_delta=timedelta(hours=1)
#         )
#         return jsonify({'access_token': access_token, 'user_type': user.user_type}), 200
#     else:
#         return jsonify({'message': 'Invalid credentials'}), 401

# # SpaceOwner adds a parking spot
# @app.route('/add_parking_spot', methods=['POST'])
# def add_parking_spot():
#     data = request.get_json()
#     new_spot = ParkingSpot(
#         spot_id=data.get('spot_id'),
#         gps_coordinates=data.get('gps_coordinates'),
#         address=data.get('address'),
#         pricing=data.get('pricing'),
#         availability_status=data.get('availability_status', True),
#         ev_charging_availability=data.get('ev_charging_availability', False),
#         surveillance_availability=data.get('surveillance_availability', False)
#     )
#     db.session.add(new_spot)
#     db.session.commit()
#     return jsonify({'message': 'Parking spot submitted for review.'}), 201

# # Route to fetch unverified parking spots for admin
# @app.route('/unverified_parking_spots', methods=['GET'])
# def unverified_parking_spots():
#     unverified_spots = ParkingSpot.query.filter_by(verified=False).all()
#     spots_list = [{
#         'id': spot.id,
#         'spot_id': spot.spot_id,
#         'gps_coordinates': spot.gps_coordinates,
#         'address': spot.address,
#         'pricing': spot.pricing,
#         'availability_status': spot.availability_status,
#         'ev_charging_availability': spot.ev_charging_availability,
#         'surveillance_availability': spot.surveillance_availability
#     } for spot in unverified_spots]
#     return jsonify(spots_list), 200


# # Admin reviews and approves/rejects a parking spot
# @app.route('/review_parking_spot/<int:spot_id>', methods=['POST'])
# def review_parking_spot(spot_id):
#     data = request.get_json()
#     action = data.get('action')  # 'approve' or 'reject'

#     spot = ParkingSpot.query.filter_by(id=spot_id).first()
#     if not spot:
#         return jsonify({'message': 'Parking spot not found.'}), 404

#     if action == 'approve':
#         spot.verified = True
#         db.session.commit()
#         return jsonify({'message': 'Parking spot approved.'}), 200

#     elif action == 'reject':
#         db.session.delete(spot)
#         db.session.commit()
#         return jsonify({'message': 'Parking spot rejected.'}), 200

#     else:
#         return jsonify({'message': 'Invalid action.'}), 400

# # VehicleOwner views verified parking spots
# @app.route('/verified_parking_spots', methods=['GET'])
# def verified_parking_spots():
#     verified_spots = ParkingSpot.query.filter_by(verified=True).all()
#     spots_list = [{
#         'id': spot.id,
#         'spot_id': spot.spot_id,
#         'gps_coordinates': spot.gps_coordinates,
#         'address': spot.address,
#         'pricing': spot.pricing,
#         'availability_status': spot.availability_status,
#         'ev_charging_availability': spot.ev_charging_availability,
#         'surveillance_availability': spot.surveillance_availability
#     } for spot in verified_spots]
#     return jsonify(spots_list), 200

# # Route to fetch VehicleOwner data from BRTA database
# @app.route('/brta', methods=['GET'])
# def fetch_vehicle_owner_data():
#     nid = request.args.get('nid')
#     if not nid:
#         return jsonify({'message': 'NID is required'}), 400
#     # Fetch data from the BRTA database (read-only)
#     brta_record = brta_session.query(BrtaData).filter_by(nid=nid).first()
#     if brta_record:
#         return jsonify({
#             'email': brta_record.email,
#             'phone_number': brta_record.phone_number,
#             'car_type': brta_record.car_type,
#             'license_plate_number': brta_record.license_plate_number,
#             'driving_license_number': brta_record.driving_license_number
#         }), 200
#     else:
#         return jsonify({'message': 'Data not found for the provided NID'}), 404

# if __name__ == '__main__':
#     app.run(debug=True, host="127.0.0.1", port=5000)


from flask_cors import CORS
from flask import Flask, request, jsonify
from flask_jwt_extended import JWTManager, create_access_token, jwt_required, get_jwt_identity
from models.user_model import User
from models.parking_spot_model import ParkingSpot
from models.brta_data_model import BrtaData
from controllers.auth_controller import register, login
from controllers.parking_controller import add_parking_spot, unverified_parking_spots, review_parking_spot, verified_parking_spots
from __init__ import db, bcrypt, jwt, create_app
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

@app.route('/add_parking_spot', methods=['POST'])
def add_parking_spot_route():
    return add_parking_spot()

@app.route('/unverified_parking_spots', methods=['GET'])
def unverified_parking_spots_route():
    return unverified_parking_spots()

@app.route('/review_parking_spot/<int:spot_id>', methods=['POST'])
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

if __name__ == '__main__':
    app.run(debug=True, host="127.0.0.1", port=5000)