from sqlalchemy.dialects.postgresql import ENUM
from __init__ import db
from geoalchemy2 import Geometry  # For spatial support

# Define the ENUM type with a name
cancellation_policy_enum = ENUM('Strict', 'Moderate', 'Flexible', name='cancellation_policy_enum', create_type=True)

class ParkingSpot(db.Model):
    __tablename__ = 'parking_spot'
    
    spot_id = db.Column(db.Integer, primary_key=True, autoincrement=True)  # Auto-incremented ID
    owner_id = db.Column(db.String(80), db.ForeignKey('user.username'), nullable=False)
    admin_id = db.Column(db.String(80), db.ForeignKey('user.username'), nullable=True)
    vehicle_type = db.Column(db.String(45), nullable=False)
    location = db.Column(db.String(45), nullable=False)
    latitude = db.Column(db.Float, nullable=False)  # Latitude
    longitude = db.Column(db.Float, nullable=False)  # Longitude
    coordinates = db.Column(Geometry('POINT', srid=4326))  # Spatial data type for POINT
    price = db.Column(db.Integer, nullable=False) 
    ev_charging = db.Column(db.Boolean, default=False) 
    surveillance = db.Column(db.Boolean, default=False)
    cancellation_policy = db.Column(cancellation_policy_enum, nullable=False) 
    availability_status = db.Column(db.Boolean, default=True)
    verified = db.Column(db.Boolean, default=False)

    __table_args__ = (
        db.Index('ix_parking_spot_coordinates', coordinates, postgresql_using='gist'),  # GiST index for spatial queries
    )
