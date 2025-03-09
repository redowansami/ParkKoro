import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as location;
import 'package:http/http.dart' as http;
import 'package:login_app/View/booking_screen.dart';

class GoogleMapPage extends StatefulWidget {
  final String username; // Add this field to accept username

  const GoogleMapPage({super.key, required this.username}); // Update the constructor

  @override
  _GoogleMapPageState createState() => _GoogleMapPageState();
}

class _GoogleMapPageState extends State<GoogleMapPage> {
  GoogleMapController? _controller;
  location.Location _location = location.Location();
  LatLng? _currentLocation;
  double _zoomLevel = 15.0;
  Set<Marker> _markers = Set();
  Set<Polyline> _polylines = Set();
  TextEditingController _searchController = TextEditingController();

  List<LatLng> parkingLocations = [];
  List<Marker> parkingMarkers = [];

  final String googleAPIKey = 'API_KEY'; // Replace with your API key
  final String backendUrl = 'http://10.0.2.2:5000/search_nearest_parking_spots'; // Your backend URL

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    // Set the current location to the specified lat: 92.5 and long: 91.2
    setState(() {
      _currentLocation = LatLng(23.725071, 90.410550);
      _markers.add(Marker(
        markerId: MarkerId('current_location'),
        position: _currentLocation!,
        infoWindow: InfoWindow(title: 'Current Location'),
        icon: BitmapDescriptor.defaultMarker,
      ));
    });
    _fetchParkingSpots(); // Fetch parking spots after setting the location
  }

  // Fetch parking spots from the backend
  Future<void> _fetchParkingSpots() async {
    if (_currentLocation == null) return;

    final response = await http.post(
      Uri.parse(backendUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'latitude': _currentLocation!.latitude,
        'longitude': _currentLocation!.longitude,
        'radius': 5000,  // 5km radius
      }),
    );

    if (response.statusCode == 200) {
      final List spots = jsonDecode(response.body);
      setState(() {
        parkingLocations.clear();
        parkingMarkers.clear();
        for (var spot in spots) {
          LatLng spotLocation = LatLng(spot['latitude'], spot['longitude']);
          parkingLocations.add(spotLocation);

          parkingMarkers.add(Marker(
            markerId: MarkerId(spot['spot_id'].toString()),
            position: spotLocation,
            infoWindow: InfoWindow(
              title: 'Spot ${spot['spot_id']}',
              snippet: 'Price: ${spot['price']}',
            ),
            onTap: () {
              _onMarkerTapped(spot);  // Pass the spot data to the handler
            },
          ));
        }
      });
    } else {
      throw Exception('Failed to load parking spots');
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller = controller;
  }

  void _zoomIn() {
    setState(() {
      _zoomLevel++;
    });
    _controller?.moveCamera(CameraUpdate.newLatLngZoom(_currentLocation!, _zoomLevel));
  }

  void _zoomOut() {
    setState(() {
      _zoomLevel--;
    });
    _controller?.moveCamera(CameraUpdate.newLatLngZoom(_currentLocation!, _zoomLevel));
  }

  void _goToCurrentLocation() {
    if (_currentLocation != null) {
      _controller?.moveCamera(CameraUpdate.newLatLngZoom(_currentLocation!, _zoomLevel));
    }
  }

  // Show Popup with Book Now button when a marker is tapped
  void _onMarkerTapped(var spot) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Parking Spot ${spot['spot_id']}'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Location: ${spot['location']}'),
              Text('Price: ${spot['price']}'),
              Text('EV Charging: ${spot['ev_charging'] ? 'Yes' : 'No'}'),
              Text('Surveillance: ${spot['surveillance'] ? 'Yes' : 'No'}'),
              Text('Cancellation Policy: ${spot['cancellation_policy']}'),
              Text('Availability: ${spot['availability_status']}'),
            ],
          ),
          actions: <Widget>[
            TextButton(
             onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
              
              // Navigate to the BookingPage with the necessary arguments
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => BookingScreen(
                      spotId: spot['spot_id'],  // Pass spotId
                      pricePerHour: double.parse(spot['price'].toString()),  // Pass pricePerHour
                      renterId: widget.username,  // Replace with actual renterId
                    ),
                  ),
                );
              },
              child: Text('Book Now'),
            ),
          ],
        );
      },
    );
  }

  // Dummy Book Now function, replace with actual booking logic
  void _bookNow(var spot) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Booking Confirmed'),
          content: Text('You have booked Spot ${spot['spot_id']} at ${spot['location']}'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Google Maps with Parking Spots'),
        actions: [
          IconButton(
            icon: Icon(Icons.list),
            onPressed: () {
              // You can add functionality to show a list of parking spots here
            },
          ),
        ],
      ),
      body: _currentLocation == null
          ? Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                GoogleMap(
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target: _currentLocation!,
                    zoom: _zoomLevel,
                  ),
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                  markers: _markers.union(parkingMarkers.toSet()), // Show current and parking spot markers
                  polylines: _polylines,
                ),
                Positioned(
                  bottom: 30,
                  left: 10,
                  child: FloatingActionButton(
                    onPressed: _goToCurrentLocation,
                    tooltip: 'Go to Current Location',
                    child: Icon(Icons.my_location),
                  ),
                ),
                Positioned(
                  bottom: 30,
                  right: 10,
                  child: Column(
                    children: [
                      FloatingActionButton(
                        onPressed: _zoomIn,
                        tooltip: 'Zoom In',
                        child: Icon(Icons.add),
                      ),
                      SizedBox(height: 10),
                      FloatingActionButton(
                        onPressed: _zoomOut,
                        tooltip: 'Zoom Out',
                        child: Icon(Icons.remove),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
