# not integrated, routes added in app.py

from flask import request, jsonify
from models.booking_model import Booking
from models.parking_spot_model import ParkingSpot
from __init__ import db
from flask_login import current_user
from datetime import datetime, timedelta

def process_payment(amount):
    """
    Dummy payment processing function.
    Replace this logic with actual payment gateway integration.
    """
    if amount > 0:
        return True, f"PAY_{datetime.now().strftime('%Y%m%d%H%M%S')}"  # Simulating a successful payment
    return False, None  # Simulating a failed payment

def create_booking():
    data = request.get_json()

    required_fields = ['spot_id', 'start_time', 'end_time', 'amount']
    if not all(field in data for field in required_fields):
        return jsonify({'message': 'Missing required fields.'}), 400

    start_time = datetime.fromisoformat(data['start_time'])
    end_time = datetime.fromisoformat(data['end_time'])
    duration = end_time - start_time

    spot = ParkingSpot.query.filter_by(spot_id=data['spot_id'], availability_status=True).first()
    if not spot:
        return jsonify({'message': 'Parking spot is not available.'}), 400

    # Attempt Payment
    payment_successful, transaction_id = process_payment(data['amount'])

    if not payment_successful:
        return jsonify({'message': 'Payment failed. Booking not created.'}), 400

    # Create Booking only if payment is successful
    new_booking = Booking(
        booking_id=f"BOOK_{datetime.now().strftime('%Y%m%d%H%M%S')}",
        renter_id=current_user.username,
        spot_id=data['spot_id'],
        booking_date=datetime.now(),
        start_time=start_time,
        end_time=end_time,
        duration=duration,
        transaction_id=transaction_id,
        cancellation_status='Pending'
    )

    # Mark spot as unavailable
    spot.availability_status = False

    db.session.add(new_booking)
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