from __init__ import db

class BrtaData(db.Model):
    __tablename__ = 'brta_data'
    __bind_key__ = 'brta'  # This tells SQLAlchemy this model is for the BRTA database

    # Set nid as the primary key since there's no 'id' column
    nid = db.Column(db.String(20), unique=True, primary_key=True)
    email = db.Column(db.String(120), nullable=False)
    phone_number = db.Column(db.String(20), nullable=False)
    car_type = db.Column(db.String(50), nullable=False)
    license_plate_number = db.Column(db.String(50), nullable=False)
    driving_license_number = db.Column(db.String(50), nullable=False)