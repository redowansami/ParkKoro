from flask import request, jsonify
from flask_jwt_extended import get_jwt_identity
from models.parking_spot_model import ParkingSpot
from __init__ import db
from models.parking_spot_model import ParkingSpot as ParkingSpotModel
from geoalchemy2.elements import WKTElement

def add_parking_spot():
    try:
        data = request.get_json()

        required_fields = ['owner_id', 'vehicle_type', 'location', 'latitude', 'longitude', 'price']
        for field in required_fields:
            if field not in data:
                return jsonify({'message': f'Missing required field: {field}'}), 400

        coordinates = f"POINT({data['longitude']} {data['latitude']})"
        new_spot = ParkingSpot(
            owner_id=data['owner_id'],
            vehicle_type=data['vehicle_type'],
            location=data['location'],
            latitude=data['latitude'],
            longitude=data['longitude'],
            coordinates=WKTElement(coordinates, srid=4326),
            price=data['price'],
            ev_charging=data.get('ev_charging', False),
            surveillance=data.get('surveillance', False),
            cancellation_policy=data.get('cancellation_policy', 'Strict'),
            availability_status=data.get('availability_status', True)
        )
        db.session.add(new_spot)
        db.session.commit()

        return jsonify({'message': 'Parking spot added successfully.'}), 201
    except Exception as e:
        return jsonify({'message': 'An error occurred', 'error': str(e)}), 500

def search_nearest_parking_spots():
    try:
        data = request.get_json()
        latitude = data.get('latitude')
        longitude = data.get('longitude')
        radius = data.get('radius')  # radius in meters

        if not latitude or not longitude or not radius:
            return jsonify({'message': 'Latitude, longitude, and radius are required.'}), 400

        # Find nearest parking spots using spatial query
        query = db.session.query(ParkingSpot).filter(
            ParkingSpot.coordinates.ST_DWithin(
                WKTElement(f'POINT({longitude} {latitude})', srid=4326),
                radius
            )
        ).all()

        spots_list = [{
            'spot_id': spot.spot_id,
            'owner_id': spot.owner_id,
            'vehicle_type': spot.vehicle_type,
            'location': spot.location,
            'latitude': spot.latitude,
            'longitude': spot.longitude,
            'price': spot.price,
            'ev_charging': spot.ev_charging,
            'surveillance': spot.surveillance,
            'cancellation_policy': spot.cancellation_policy,
            'availability_status': spot.availability_status
        } for spot in query]

        return jsonify(spots_list), 200
    except Exception as e:
        return jsonify({'message': 'An error occurred', 'error': str(e)}), 500


def unverified_parking_spots():
    unverified_spots = ParkingSpot.query.filter_by(verified=False).all()
    spots_list = [{
        'spot_id': spot.spot_id,  # spot_id is now an integer
        'owner_id': spot.owner_id,
        'admin_id': spot.admin_id,
        'vehicle_type': spot.vehicle_type,
        'location': spot.location,
        'latitude': spot.latitude,  # Replaced gps_coordinates with latitude
        'longitude': spot.longitude,  # Added longitude field
        'price': spot.price,
        'ev_charging': spot.ev_charging,
        'surveillance': spot.surveillance,
        'cancellation_policy': spot.cancellation_policy,
        'availability_status': spot.availability_status
    } for spot in unverified_spots]
    return jsonify(spots_list), 200


def review_parking_spot(spot_id):
    try:
        data = request.get_json()
        action = data.get('action')
       
        # Query the ParkingSpot by the spot_id (integer)
        spot = ParkingSpot.query.filter_by(spot_id=spot_id).first()  # Use filter_by since spot_id is an integer now
        if not spot:
            return jsonify({'message': 'Parking spot not found.'}), 404

        if action == 'accept':
            spot.verified = True  
            db.session.commit()
            return jsonify({'message': 'Parking spot approved.'}), 200

        elif action == 'delete':
            db.session.delete(spot)
            db.session.commit()
            return jsonify({'message': 'Parking spot deleted.'}), 200

        else:
            return jsonify({'message': 'Invalid action.'}), 400

    except Exception as e:
        return jsonify({'message': 'An error occurred', 'error': str(e)}), 500


def verified_parking_spots():
    verified_spots = ParkingSpot.query.filter_by(verified=True).all()
    spots_list = [{
        'spot_id': spot.spot_id,  # spot_id is now an integer
        'owner_id': spot.owner_id,
        'admin_id': spot.admin_id,
        'vehicle_type': spot.vehicle_type,
        'location': spot.location,
        'latitude': spot.latitude,  # Replaced gps_coordinates with latitude
        'longitude': spot.longitude,  # Added longitude field
        'price': spot.price,
        'ev_charging': spot.ev_charging,
        'surveillance': spot.surveillance,
        'cancellation_policy': spot.cancellation_policy,
        'availability_status': spot.availability_status
    } for spot in verified_spots]
    return jsonify(spots_list), 200


def get_parking_spots_by_owner():
    owner_id = request.json.get("owner_id")
    if owner_id is None:
        return jsonify({'message': 'Owner ID cannot be null'}), 400
    if not owner_id:
        return jsonify({'message': 'Owner ID is required'}), 400

    spots = ParkingSpot.query.filter_by(owner_id=owner_id).all()

    spots_list = [{
        'spot_id': spot.spot_id,  # spot_id is now an integer
        'vehicle_type': spot.vehicle_type,
        'location': spot.location,
        'latitude': spot.latitude,  # Replaced gps_coordinates with latitude
        'longitude': spot.longitude,  # Added longitude field
        'price': spot.price,
        'ev_charging': spot.ev_charging,
        'surveillance': spot.surveillance,
        'cancellation_policy': spot.cancellation_policy,
        'availability_status': spot.availability_status
    } for spot in spots]

    return jsonify(spots_list), 200

def edit_parking_spot():
    data = request.get_json()
    spot_id = data.get('spot_id')

    spot = ParkingSpot.query.filter_by(spot_id=spot_id).first()
    
    if not spot:
        return jsonify({'message': 'Parking spot not found.'}), 404

    # Update the parking spot information with the new data
    spot.price = data.get('price', spot.price)
    spot.cancellation_policy = data.get('cancellation_policy', spot.cancellation_policy)
    spot.availability_status = data.get('availability_status', spot.availability_status)

    db.session.commit()

    return jsonify({'message': 'Parking spot updated successfully.'}), 200