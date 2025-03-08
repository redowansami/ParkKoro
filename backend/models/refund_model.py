from __init__ import db;
from sqlalchemy.dialects.postgresql import ENUM

refund_status_enum = ENUM('Pending', 'Completed', name='refund_status_enum', create_type=True)

class RefundRequest(db.Model):
    __tablename__ = 'refund_request'
    refund_id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    booking_id = db.Column(db.String(45), nullable=False)
    renter_id = db.Column(db.String(80), nullable=False)
    amount = db.Column(db.Numeric(10, 2), nullable=False)
    refund_status = db.Column(refund_status_enum, nullable=False, default='Pending')

    def __repr__(self):
        return f"<RefundRequest {self.refund_id}>"