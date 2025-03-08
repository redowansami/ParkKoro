# Not integrated

from sqlalchemy.dialects.postgresql import ENUM
from __init__ import db

# Define the ENUM type for cancellation status
cancellation_status_enum = ENUM('Pending', 'Cancelled', 'Completed', name='cancellation_status_enum', create_type=True)

class Booking(db.Model):
    __tablename__ = 'booking'
    booking_id = db.Column(db.String(45), primary_key=True)  # BookingID (PK)
    renter_id = db.Column(db.String(80), db.ForeignKey('user.username'), nullable=False)  # RenterID (FK)
    spot_id = db.Column(db.Integer, db.ForeignKey('parking_spot.spot_id'), nullable=False)  # SpotID (FK)
    booking_date = db.Column(db.DateTime, nullable=False)  # BookingDate
    start_time = db.Column(db.DateTime, nullable=False)  # StartTime
    end_time = db.Column(db.DateTime, nullable=False)  # EndTime
    duration = db.Column(db.Interval, nullable=False)  # Duration
    cancellation_status = db.Column(cancellation_status_enum, nullable=False, default='Pending')  # CancellationStatus

    def __repr__(self):
        return f"<Booking {self.booking_id}>"