# not integrated, routes added in app.py

import random
import string
from flask import request, jsonify
import requests
from models.payment_model import Payment
from models.booking_model import Booking
from models.parking_spot_model import ParkingSpot
from __init__ import db
from flask_login import current_user
from datetime import datetime, timedelta


SSLCommerzValidationURL = "https://sandbox.sslcommerz.com/validator/api/validationserverAPI.php"

def generate_transaction_id():
    return ''.join(random.choices(string.ascii_letters + string.digits, k=10))

def create_booking():
    data = request.get_json()

    required_fields = ['spot_id', 'start_time', 'end_time', 'amount', 'renter_id']
    if not all(field in data for field in required_fields):
        return jsonify({'message': 'Missing required fields.'}), 400

    start_time = datetime.fromisoformat(data['start_time'])
    end_time = datetime.fromisoformat(data['end_time'])
    duration = end_time - start_time

    transaction_id = generate_transaction_id()

    new_booking = Booking(
        booking_id=f"BOOK_{datetime.now().strftime('%Y%m%d%H%M%S')}",
        renter_id=data['renter_id'],
        spot_id=data['spot_id'],
        booking_date=datetime.now(),
        start_time=start_time,
        end_time=end_time,
        duration=duration,
        cancellation_status='Pending'
    )

    # Add the booking to the database
    db.session.add(new_booking)
    db.session.commit()

    # Mark the parking spot as unavailable
    spot = ParkingSpot.query.filter_by(spot_id=data['spot_id']).first()

    # Store Payment Information (payment status is "Completed" by default)
    new_payment = Payment(
        transaction_id=transaction_id,  # Generated transaction ID
        amount=data['amount'],
        status='Completed',  # Since the payment is assumed to be validated
        booking_id=new_booking.booking_id,  # Associate with booking
        refund_status='Pending'  # Assuming no refund for successful payments
    )

    # Save payment details
    db.session.add(new_payment)
    db.session.commit()

    return jsonify({
        'message': 'Booking confirmed after successful payment.',
        'booking_id': new_booking.booking_id,
        'transaction_id': transaction_id
    }), 201

def cancel_booking(booking_id):
    booking = Booking.query.filter_by(booking_id=booking_id).first()
    if not booking:
        return jsonify({'message': 'Booking not found.'}), 404

    # Check if the booking can be cancelled (e.g., not already completed)
    if booking.cancellation_status == 'Completed':
        return jsonify({'message': 'Booking cannot be cancelled as it is already completed.'}), 400

    # Update booking status
    booking.cancellation_status = 'Cancelled'

    # Update parking spot availability
    spot = ParkingSpot.query.filter_by(spot_id=booking.spot_id).first()
    if spot:
        spot.availability_status = True

    db.session.commit()
    return jsonify({'message': 'Booking cancelled successfully.'}), 200

def view_booking_details(booking_id):
    booking = Booking.query.filter_by(booking_id=booking_id).first()
    if not booking:
        return jsonify({'message': 'Booking not found.'}), 404

    booking_details = {
        'booking_id': booking.booking_id,
        'renter_id': booking.renter_id,
        'spot_id': booking.spot_id,
        'booking_date': booking.booking_date.isoformat(),
        'start_time': booking.start_time.isoformat(),
        'end_time': booking.end_time.isoformat(),
        'duration': str(booking.duration),
        'cancellation_status': booking.cancellation_status
    }

    return jsonify(booking_details), 200

def update_availability(spot_id):
    spot = ParkingSpot.query.filter_by(spot_id=spot_id).first()
    if not spot:
        return jsonify({'message': 'Parking spot not found.'}), 404

    # Toggle availability status
    spot.availability_status = not spot.availability_status
    db.session.commit()

    return jsonify({'message': 'Availability status updated.', 'availability_status': spot.availability_status}), 200