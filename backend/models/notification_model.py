from datetime import datetime
from __init__ import db

class Notification(db.Model):
    __tablename__ = "notifications"

    notification_ID = db.Column(db.Integer, primary_key=True, autoincrement=True)
    message_content = db.Column(db.String(255), nullable=False)
    timestamp = db.Column(db.DateTime, default=datetime.utcnow)

    def to_dict(self):
        return {
            "notification_ID": self.notification_ID,
            "message_content": self.message_content,
            "timestamp": self.timestamp.strftime("%Y-%m-%d %H:%M:%S")
        }
