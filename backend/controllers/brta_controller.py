from flask import request, jsonify
from models.brta_data_model import BrtaData
from sqlalchemy.orm import scoped_session
from __init__ import BrtaSession  # Ensure BrtaSession is imported

def fetch_vehicle_owner_data():
    nid = request.args.get('nid')
    print("Received NID:", nid)  # Debugging
    if not nid:
        return jsonify({'message': 'NID is required'}), 400

    # Debugging: Check if BrtaSession is callable
    if not callable(BrtaSession):
        print("BrtaSession is not callable. Check initialization.")  # Debugging
        return jsonify({'message': 'BrtaSession is not callable. Check initialization.'}), 500

    # Create a scoped session from BrtaSession
    session = scoped_session(BrtaSession)
    print("Scoped session created successfully:", session)  # Debugging

    try:
        # Debugging: Check if the session can query the database
        print("Querying BRTA database for NID:", nid)  # Debugging
        brta_record = session.query(BrtaData).filter_by(nid=nid).first()
        if brta_record:
            print("BRTA record found:", brta_record)  # Debugging
            return jsonify({
                'email': brta_record.email,
                'phone_number': brta_record.phone_number,
                'car_type': brta_record.car_type,
                'license_plate_number': brta_record.license_plate_number,
                'driving_license_number': brta_record.driving_license_number
            }), 200
        else:
            print("No BRTA record found for NID:", nid)  # Debugging
            return jsonify({'message': 'Data not found for the provided NID'}), 404
    except Exception as e:
        print("Error during database query:", str(e))  # Debugging
        return jsonify({'message': 'An error occurred', 'error': str(e)}), 500
    finally:
        # Ensure session is properly closed
        session.remove()
        print("Session closed successfully.")  # Debugging