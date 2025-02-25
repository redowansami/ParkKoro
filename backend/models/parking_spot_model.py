from sqlalchemy.dialects.postgresql import ENUM
from __init__ import db

# Define the ENUM type with a name
cancellation_policy_enum = ENUM('Strict', 'Moderate', 'Flexible', name='cancellation_policy_enum', create_type=True)

class ParkingSpot(db.Model):
    __tablename__ = 'parking_spot'
    
    spot_id = db.Column(db.String(45), primary_key=True, nullable=False)  # Set as primary key
    owner_id = db.Column(db.String(80), db.ForeignKey('user.username'), nullable=False)
    admin_id = db.Column(db.String(80), db.ForeignKey('user.username'), nullable=True)
    vehicle_type = db.Column(db.String(45), nullable=False)
    location = db.Column(db.String(45), nullable=False)
    gps_coordinates = db.Column(db.String(45), nullable=False)  # Will change to use POINT type
    price = db.Column(db.Integer, nullable=False) 
    ev_charging = db.Column(db.Boolean, default=False) 
    surveillance = db.Column(db.Boolean, default=False)
    cancellation_policy = db.Column(cancellation_policy_enum, nullable=False) 
    availability_status = db.Column(db.Boolean, default=True)
    verified = db.Column(db.Boolean, default=False)