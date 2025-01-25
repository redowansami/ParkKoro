// class ParkingSpot {
//   String spotID;
//   String gpsCoordinates;
//   String address;
//   double pricing;
//   bool availabilityStatus;
//   bool evChargingAvailability;
//   bool surveillanceAvailability;

//   ParkingSpot({
//     required this.spotID,
//     required this.gpsCoordinates,
//     required this.address,
//     required this.pricing,
//     required this.availabilityStatus,
//     required this.evChargingAvailability,
//     required this.surveillanceAvailability,
//   });

//   String viewAvailability() {
//     return availabilityStatus ? "Available" : "Unavailable";
//   }

//   Map<String, dynamic> getDetails() {
//     return {
//       'Spot ID': spotID,
//       'GPS Coordinates': gpsCoordinates,
//       'Address': address,
//       'Pricing': pricing,
//       'Availability': availabilityStatus,
//       'EV Charging': evChargingAvailability,
//       'Surveillance': surveillanceAvailability,
//     };
//   }

//   void integrateMapLocation() {
//     // Logic for map integration
//   }

//   void viewFeedback() {
//     // Logic to fetch and display feedback
//   }
// }

// lib/models/parking_spot.dart
class ParkingSpot {
  String spotID;
  String gpsCoordinates;
  String address;
  double pricing;
  bool availabilityStatus;
  bool evChargingAvailability;
  bool surveillanceAvailability;

  ParkingSpot({
    required this.spotID,
    required this.gpsCoordinates,
    required this.address,
    required this.pricing,
    required this.availabilityStatus,
    required this.evChargingAvailability,
    required this.surveillanceAvailability,
  });

  String viewAvailability() {
    return availabilityStatus ? "Available" : "Unavailable";
  }

  Map<String, dynamic> toJson() {
    return {
      'spot_id': spotID,
      'gps_coordinates': gpsCoordinates,
      'address': address,
      'pricing': pricing,
      'availability_status': availabilityStatus,
      'ev_charging_availability': evChargingAvailability,
      'surveillance_availability': surveillanceAvailability,
    };
  }

  static ParkingSpot fromJson(Map<String, dynamic> json) {
    return ParkingSpot(
      spotID: json['spot_id'],
      gpsCoordinates: json['gps_coordinates'],
      address: json['address'],
      pricing: json['pricing'],
      availabilityStatus: json['availability_status'],
      evChargingAvailability: json['ev_charging_availability'],
      surveillanceAvailability: json['surveillance_availability'],
    );
  }
}