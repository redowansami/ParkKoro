from flask import request, jsonify
from models.notification_model import Notification
from __init__ import db

def send_notification():
    data = request.get_json()

    if not data or "message_content" not in data:
        return jsonify({"message": "Message content is required"}), 400

    new_notification = Notification(
        message_content=data["message_content"]
    )
    db.session.add(new_notification)
    db.session.commit()

    return jsonify({"message": "Notification sent successfully", "notification": new_notification.to_dict()}), 201


def view_notifications():
    notifications = Notification.query.order_by(Notification.timestamp.desc()).all()

    return jsonify({"notifications": [notif.to_dict() for notif in notifications]}), 200
