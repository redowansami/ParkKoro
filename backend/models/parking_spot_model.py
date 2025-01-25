from __init__ import db

class ParkingSpot(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    spot_id = db.Column(db.String(50), nullable=False)
    gps_coordinates = db.Column(db.String(100), nullable=False)
    address = db.Column(db.String(255), nullable=False)
    pricing = db.Column(db.Float, nullable=False)
    availability_status = db.Column(db.Boolean, default=True)
    ev_charging_availability = db.Column(db.Boolean, default=False)
    surveillance_availability = db.Column(db.Boolean, default=False)
    verified = db.Column(db.Boolean, default=False)  # True if approved by admin, False otherwise