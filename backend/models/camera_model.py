from sqlalchemy import ForeignKey
from sqlalchemy.orm import relationship
from __init__ import db

class Camera(db.Model):
    __tablename__ = 'camera'
    camera_id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    owner_id = db.Column(db.String(80), db.ForeignKey('user.username'), nullable=False)  # Reference to the User table
    url = db.Column(db.String(200), nullable=False)

    def __repr__(self):
        return f"<Camera {self.camera_id}>"
