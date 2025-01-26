from flask import request, jsonify
from models.parking_spot_model import ParkingSpot
from __init__ import db
from flask_login import current_user


def add_parking_spot():
    data = request.get_json()
    print(data)
    
    owner_id = current_user.username 
    
    admin_id = "admin_username"  
    new_spot = ParkingSpot(
        spot_id=data.get('spot_id'),
        owner_id=owner_id, 
        admin_id=admin_id, 
        vehicle_type=data.get('vehicle_type'),
        location=data.get('location'),
        gps_coordinates=data.get('gps_coordinates'),
        price=data.get('price'),
        ev_charging=data.get('ev_charging', False),
        surveillance=data.get('surveillance', False),
        cancellation_policy=data.get('cancellation_policy'),
        availability_status=data.get('availability_status', True)
    )

    db.session.add(new_spot)
    db.session.commit()
    return jsonify({'message': 'Parking spot submitted for review.'}), 201

def unverified_parking_spots():
    unverified_spots = ParkingSpot.query.filter_by(verified=False).all()
    spots_list = [{
        'id': spot.id,
        'spot_id': spot.spot_id,
        'owner_id': spot.owner_id,
        'admin_id': spot.admin_id,
        'vehicle_type': spot.vehicle_type,
        'location': spot.location,
        'gps_coordinates': spot.gps_coordinates,
        'price': spot.price,
        'ev_charging': spot.ev_charging,
        'surveillance': spot.surveillance,
        'cancellation_policy': spot.cancellation_policy,
        'availability_status': spot.availability_status
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
        'owner_id': spot.owner_id,
        'admin_id': spot.admin_id,
        'vehicle_type': spot.vehicle_type,
        'location': spot.location,
        'gps_coordinates': spot.gps_coordinates,
        'price': spot.price,
        'ev_charging': spot.ev_charging,
        'surveillance': spot.surveillance,
        'cancellation_policy': spot.cancellation_policy,
        'availability_status': spot.availability_status
    } for spot in verified_spots]
    return jsonify(spots_list), 200