from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from flask_bcrypt import Bcrypt
from flask_jwt_extended import JWTManager
from flask_cors import CORS

# Initialize extensions
db = SQLAlchemy()
bcrypt = Bcrypt()
jwt = JWTManager()

def create_app():
    """Factory function to create and configure the Flask app."""
    app = Flask(__name__)
    CORS(app)

    # Configuration for the main app database (mydb)
    app.config['SQLALCHEMY_DATABASE_URI'] = 'postgresql://sami:sami@localhost/mydb'
    app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
    app.config['JWT_SECRET_KEY'] = 'your_jwt_secret_key'

    # Configuration for the BRTA database (read-only)
    app.config['SQLALCHEMY_BINDS'] = {
        'brta': 'postgresql://sami:sami@localhost/brta'
    }

    # Initialize extensions with the app
    db.init_app(app)
    bcrypt.init_app(app)
    jwt.init_app(app)

    # Import and register models
    from models.user_model import User
    from models.parking_spot_model import ParkingSpot
    from models.brta_data_model import BrtaData

    # Create database tables
    with app.app_context():
        db.create_all()

    return app