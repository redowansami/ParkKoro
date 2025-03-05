class ParkingSpot {
  String spotID;
  String ownerID;
  String? adminID;
  String vehicleType;
  String location;
  String gpsCoordinates;
  int price;
  bool evCharging;
  bool surveillance;
  String cancellationPolicy;
  bool availabilityStatus;
  bool verified; 

  ParkingSpot({
    required this.spotID,
    required this.ownerID,
    this.adminID,
    required this.vehicleType,
    required this.location,
    required this.gpsCoordinates,
    required this.price,
    required this.evCharging,
    required this.surveillance,
    required this.cancellationPolicy,
    required this.availabilityStatus,
    this.verified = false, // Default to false
  });

  String viewAvailability() {
    return availabilityStatus ? "Available" : "Unavailable";
  }

  Map<String, dynamic> toJson() {
    return {
      'spot_id': spotID,
      'owner_id': ownerID,
      'admin_id': adminID,
      'vehicle_type': vehicleType,
      'location': location,
      'gps_coordinates': gpsCoordinates,
      'price': price,
      'ev_charging': evCharging,
      'surveillance': surveillance,
      'cancellation_policy': cancellationPolicy,
      'availability_status': availabilityStatus,
      'verified': verified, // Include this in the JSON payload
    };
  }

  static ParkingSpot fromJson(Map<String, dynamic> json) {
    return ParkingSpot(
      spotID: json['spot_id'],
      ownerID: json['owner_id'],
      adminID: json['admin_id'],
      vehicleType: json['vehicle_type'],
      location: json['location'],
      gpsCoordinates: json['gps_coordinates'],
      price: json['price'],
      evCharging: json['ev_charging'],
      surveillance: json['surveillance'],
      cancellationPolicy: json['cancellation_policy'],
      availabilityStatus: json['availability_status'],
      verified: json['verified'] ?? false, // Handle null case
    );
  }
}