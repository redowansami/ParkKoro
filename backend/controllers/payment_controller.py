from flask import request, jsonify
import requests
from models.payment_model import Payment
from models.booking_model import Booking
from __init__ import db
from datetime import datetime

def process_payment():
    data = request.get_json()

    # Validate required fields
    required_fields = ['booking_id', 'amount', 'vehicle_owner']
    if not all(field in data for field in required_fields):
        return jsonify({'message': 'Missing required fields.'}), 400

    # Check if the booking exists
    booking = Booking.query.filter_by(booking_id=data['booking_id']).first()
    if not booking:
        return jsonify({'message': 'Booking not found.'}), 404

    # Create a new payment record
    new_payment = Payment(
        transaction_id=f"PAY_{datetime.now().strftime('%Y%m%d%H%M%S')}",  # Generate a unique transaction ID
        booking_id=data['booking_id'],
        amount=data['amount'],
        status='Completed',  # Simulate a successful payment for now
        refund_status='Pending'
    )

    db.session.add(new_payment)
    db.session.commit()

    return jsonify({'message': 'Payment processed successfully.', 'transaction_id': new_payment.transaction_id}), 201

def initiate_refund(transaction_id):
    payment = Payment.query.filter_by(transaction_id=transaction_id).first()
    if not payment:
        return jsonify({'message': 'Payment not found.'}), 404

    # Check if the payment is eligible for a refund
    if payment.status != 'Completed':
        return jsonify({'message': 'Payment is not eligible for a refund.'}), 400

    # Update refund status
    payment.refund_status = 'Completed'  # Simulate a successful refund for now
    db.session.commit()

    return jsonify({'message': 'Refund initiated successfully.'}), 200

def get_payment_details(transaction_id):
    payment = Payment.query.filter_by(transaction_id=transaction_id).first()
    if not payment:
        return jsonify({'message': 'Payment not found.'}), 404

    payment_details = {
        'transaction_id': payment.transaction_id,
        'booking_id': payment.booking_id,
        'amount': float(payment.amount),
        'status': payment.status,
        'transaction_date': payment.transaction_date.isoformat(),
        'refund_status': payment.refund_status
    }

    return jsonify(payment_details), 200