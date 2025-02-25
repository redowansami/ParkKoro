from sqlalchemy.dialects.postgresql import ENUM
from __init__ import db

# Define the ENUM type for payment and refund status
payment_status_enum = ENUM('Pending', 'Completed', 'Failed', name='payment_status_enum', create_type=True)
refund_status_enum = ENUM('Pending', 'Completed', 'Failed', name='refund_status_enum', create_type=True)

class Payment(db.Model):
    __tablename__ = 'payment'
    transaction_id = db.Column(db.String(45), primary_key=True)  # TransactionID (PK)
    booking_id = db.Column(db.String(45), db.ForeignKey('booking.booking_id'), nullable=False)  # BookingID (FK)
    amount = db.Column(db.Numeric(10, 2), nullable=False)  # Amount
    status = db.Column(payment_status_enum, nullable=False, default='Pending')  # Status
    transaction_date = db.Column(db.DateTime, nullable=False, default=db.func.current_timestamp(), )  # TransactionDate
    refund_status = db.Column(refund_status_enum, nullable=False, default='Pending')  # RefundStatus

    def __repr__(self):
        return f"<Payment {self.transaction_id}>"