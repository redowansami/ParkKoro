from __init__ import db

class User(db.Model):
    __tablename__ = 'user'

    username = db.Column(db.String(80), primary_key=True)  # Make username the primary key
    password = db.Column(db.String(200), nullable=False)
    user_type = db.Column(db.String(50), nullable=False)
    nid = db.Column(db.String(20), unique=True, nullable=True)
    email = db.Column(db.String(120), nullable=False)
    phone = db.Column(db.String(20), nullable=False)
    car_type = db.Column(db.String(50), nullable=True)
    license_plate_number = db.Column(db.String(50), nullable=True)
    driving_license_number = db.Column(db.String(50), nullable=True)


    def __repr__(self):
        return f"<User {self.username}>"
