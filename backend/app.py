from flask import Flask, request, jsonify
from flask_sqlalchemy import SQLAlchemy
from flask_bcrypt import Bcrypt
from flask_jwt_extended import JWTManager, create_access_token
from flask_cors import CORS
from datetime import timedelta

app = Flask(__name__)
CORS(app)

# Configuration for PostgreSQL
app.config['SQLALCHEMY_DATABASE_URI'] = 'postgresql://sami:sami@localhost/mydb'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
app.config['JWT_SECRET_KEY'] = 'your_jwt_secret_key'
db = SQLAlchemy(app)
bcrypt = Bcrypt(app)
jwt = JWTManager(app)

# User model
class User(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(80), unique=True, nullable=False)
    password = db.Column(db.String(200), nullable=False)
    user_type = db.Column(db.String(50), nullable=False)  # VehicleOwner, SpaceOwner, Admin
    nid = db.Column(db.String(20), unique=True, nullable=True)  # Optional, used for VehicleOwner
    email = db.Column(db.String(120), nullable=False)
    phone = db.Column(db.String(20), nullable=False)
    car_type = db.Column(db.String(50), nullable=True)  # Only for VehicleOwner
    license_plate_number = db.Column(db.String(50), nullable=True)  # Only for VehicleOwner
    driving_license_number = db.Column(db.String(50), nullable=True)  # Only for VehicleOwner

# Initialize database
@app.before_request
def create_tables():
    db.create_all()

# Test Route
@app.route('/', methods=['GET'])
def home():
    return "Backend is working!"

# Registration route
@app.route('/register', methods=['POST'])
def register():
    data = request.get_json()
    username = data.get('username')
    password = data.get('password')
    user_type = data.get('user_type')
    nid = data.get('nid')
    email = data.get('email')
    phone = data.get('phone')
    car_type = data.get('car_type')
    license_plate_number = data.get('license_plate_number')
    driving_license_number = data.get('driving_license_number')

    if not username or not password or not user_type or not email or not phone:
        return jsonify({'message': 'Missing required fields'}), 400

    if user_type == 'VehicleOwner' and not nid:
        return jsonify({'message': 'NID is required for VehicleOwner'}), 400

    if User.query.filter_by(username=username).first():
        return jsonify({'message': 'Username already exists'}), 400

    hashed_password = bcrypt.generate_password_hash(password).decode('utf-8')
    new_user = User(
        username=username,
        password=hashed_password,
        user_type=user_type,
        nid=nid,
        email=email,
        phone=phone,
        car_type=car_type if user_type == 'VehicleOwner' else None,
        license_plate_number=license_plate_number if user_type == 'VehicleOwner' else None,
        driving_license_number=driving_license_number if user_type == 'VehicleOwner' else None
    )
    db.session.add(new_user)
    db.session.commit()

    return jsonify({'message': 'User registered successfully'}), 201

# Login route
@app.route('/login', methods=['POST'])
def login():
    data = request.get_json()
    username = data.get('username')
    password = data.get('password')

    user = User.query.filter_by(username=username).first()
    if user and bcrypt.check_password_hash(user.password, password):
        access_token = create_access_token(
            identity={
                'username': user.username,
                'user_type': user.user_type
            },
            expires_delta=timedelta(hours=1)
        )
        return jsonify({'access_token': access_token, 'user_type': user.user_type}), 200
    else:
        return jsonify({'message': 'Invalid credentials'}), 401

# Route to fetch VehicleOwner data from BRTA database
@app.route('/brta', methods=['GET'])
def fetch_vehicle_owner_data():
    nid = request.args.get('nid')
    if not nid:
        return jsonify({'message': 'NID is required'}), 400

    # Simulate fetching data from BRTA database
    # Replace this part with actual database queries if available
    brta_data = {
        '123456789': {
            'email': 'owner@example.com',
            'phone_number': '0123456789',
            'car_type': 'Sedan',
            'license_plate_number': 'XYZ1234',
            'driving_license_number': 'DL12345'
        }
    }

    if nid in brta_data:
        return jsonify(brta_data[nid]), 200
    else:
        return jsonify({'message': 'Data not found for the provided NID'}), 404

if __name__ == '__main__':
    app.run(debug=True, host="127.0.0.1", port=5000)