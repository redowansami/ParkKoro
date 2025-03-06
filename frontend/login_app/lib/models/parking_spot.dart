// class ParkingSpot {
//   String spotID;
//   String ownerID;
//   String? adminID;
//   String vehicleType;
//   String location;
//   String gpsCoordinates;
//   int price;
//   bool evCharging;
//   bool surveillance;
//   String cancellationPolicy;
//   bool availabilityStatus;
//   bool verified; 

//   ParkingSpot({
//     required this.spotID,
//     required this.ownerID,
//     this.adminID,
//     required this.vehicleType,
//     required this.location,
//     required this.gpsCoordinates,
//     required this.price,
//     required this.evCharging,
//     required this.surveillance,
//     required this.cancellationPolicy,
//     required this.availabilityStatus,
//     this.verified = false, // Default to false
//   });

//   String viewAvailability() {
//     return availabilityStatus ? "Available" : "Unavailable";
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'spot_id': spotID,
//       'owner_id': ownerID,
//       'admin_id': adminID,
//       'vehicle_type': vehicleType,
//       'location': location,
//       'gps_coordinates': gpsCoordinates,
//       'price': price,
//       'ev_charging': evCharging,
//       'surveillance': surveillance,
//       'cancellation_policy': cancellationPolicy,
//       'availability_status': availabilityStatus,
//       'verified': verified, // Include this in the JSON payload
//     };
//   }

//   static ParkingSpot fromJson(Map<String, dynamic> json) {
//     return ParkingSpot(
//       spotID: json['spot_id'],
//       ownerID: json['owner_id'],
//       adminID: json['admin_id'],
//       vehicleType: json['vehicle_type'],
//       location: json['location'],
//       gpsCoordinates: json['gps_coordinates'],
//       price: json['price'],
//       evCharging: json['ev_charging'],
//       surveillance: json['surveillance'],
//       cancellationPolicy: json['cancellation_policy'],
//       availabilityStatus: json['availability_status'],
//       verified: json['verified'] ?? false, // Handle null case
//     );
//   }
// }

class ParkingSpot {
  int spotID;  // Changed to integer for spotID
  String ownerID;
  String? adminID;
  String vehicleType;
  String location;
  double latitude;  // Latitude for the location
  double longitude;  // Longitude for the location
  int price;
  bool evCharging;
  bool surveillance;
  String cancellationPolicy;
  bool availabilityStatus;
  bool verified;

  ParkingSpot({
    required this.spotID,  // Integer spotID
    required this.ownerID,
    this.adminID,
    required this.vehicleType,
    required this.location,
    required this.latitude,
    required this.longitude,
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
      'owner_id': ownerID,
      'admin_id': adminID,
      'vehicle_type': vehicleType,
      'location': location,
      'latitude': latitude,
      'longitude': longitude,
      'price': price,
      'ev_charging': evCharging,
      'surveillance': surveillance,
      'cancellation_policy': cancellationPolicy,
      'availability_status': availabilityStatus,
      'verified': verified, // Include verified in the payload
    };
  }

  static ParkingSpot fromJson(Map<String, dynamic> json) {
    return ParkingSpot(
      spotID: json['spot_id'],  // Parse the spot_id as integer
      ownerID: json['owner_id'],
      adminID: json['admin_id'],
      vehicleType: json['vehicle_type'],
      location: json['location'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      price: json['price'],
      evCharging: json['ev_charging'],
      surveillance: json['surveillance'],
      cancellationPolicy: json['cancellation_policy'],
      availabilityStatus: json['availability_status'],
      verified: json['verified'] ?? false, // Handle null case
    );
  }
}
