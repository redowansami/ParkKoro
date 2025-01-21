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

  Map<String, dynamic> getDetails() {
    return {
      'Spot ID': spotID,
      'GPS Coordinates': gpsCoordinates,
      'Address': address,
      'Pricing': pricing,
      'Availability': availabilityStatus,
      'EV Charging': evChargingAvailability,
      'Surveillance': surveillanceAvailability,
    };
  }

  void integrateMapLocation() {
    // Logic for map integration
  }

  void viewFeedback() {
    // Logic to fetch and display feedback
  }
}
