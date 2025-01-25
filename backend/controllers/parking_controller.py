from flask import request, jsonify
from models.parking_spot_model import ParkingSpot
from __init__ import db

def add_parking_spot():
    data = request.get_json()
    new_spot = ParkingSpot(
        spot_id=data.get('spot_id'),
        gps_coordinates=data.get('gps_coordinates'),
        address=data.get('address'),
        pricing=data.get('pricing'),
        availability_status=data.get('availability_status', True),
        ev_charging_availability=data.get('ev_charging_availability', False),
        surveillance_availability=data.get('surveillance_availability', False)
    )
    db.session.add(new_spot)
    db.session.commit()
    return jsonify({'message': 'Parking spot submitted for review.'}), 201

def unverified_parking_spots():
    unverified_spots = ParkingSpot.query.filter_by(verified=False).all()
    spots_list = [{
        'id': spot.id,
        'spot_id': spot.spot_id,
        'gps_coordinates': spot.gps_coordinates,
        'address': spot.address,
        'pricing': spot.pricing,
        'availability_status': spot.availability_status,
        'ev_charging_availability': spot.ev_charging_availability,
        'surveillance_availability': spot.surveillance_availability
    } for spot in unverified_spots]
    return jsonify(spots_list), 200

def review_parking_spot(spot_id):
    data = request.get_json()
    action = data.get('action')  # 'approve' or 'reject'

    spot = ParkingSpot.query.filter_by(id=spot_id).first()
    if not spot:
        return jsonify({'message': 'Parking spot not found.'}), 404

    if action == 'approve':
        spot.verified = True
        db.session.commit()
        return jsonify({'message': 'Parking spot approved.'}), 200

    elif action == 'reject':
        db.session.delete(spot)
        db.session.commit()
        return jsonify({'message': 'Parking spot rejected.'}), 200

    else:
        return jsonify({'message': 'Invalid action.'}), 400

def verified_parking_spots():
    verified_spots = ParkingSpot.query.filter_by(verified=True).all()
    spots_list = [{
        'id': spot.id,
        'spot_id': spot.spot_id,
        'gps_coordinates': spot.gps_coordinates,
        'address': spot.address,
        'pricing': spot.pricing,
        'availability_status': spot.availability_status,
        'ev_charging_availability': spot.ev_charging_availability,
        'surveillance_availability': spot.surveillance_availability
    } for spot in verified_spots]
    return jsonify(spots_list), 200