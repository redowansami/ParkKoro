import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as location;
import 'package:http/http.dart' as http;

class GoogleMapPage extends StatefulWidget {
  const GoogleMapPage({super.key});

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

  List<LatLng> randomLocations = [];
  List<Marker> randomMarkers = [];
  LatLng? selectedDestination;

  final String googleAPIKey = 'AIzaSyDdpVNmafi9ZXaXaWbmc7irozN9Qllvh1A'; // Replace with your API key

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  // Generate random location within a 5 km radius
  LatLng _generateRandomLocation(LatLng center, double radius) {
    Random random = Random();
    double angle = random.nextDouble() * 2 * pi;
    double distance = random.nextDouble() * radius;

    double lat = center.latitude + (distance / 111.32); // 1 degree = 111.32 km
    double lng = center.longitude + (distance / (111.32 * cos(center.latitude * pi / 180)));

    return LatLng(lat, lng);
  }

  Future<void> _getCurrentLocation() async {
    var locationData = await _location.getLocation();
    setState(() {
      _currentLocation = LatLng(locationData.latitude!, locationData.longitude!);
      _markers.add(Marker(
        markerId: MarkerId('current_location'),
        position: _currentLocation!,
        infoWindow: InfoWindow(title: 'Current Location'),
        icon: BitmapDescriptor.defaultMarker,
      ));

      // Generate 4-5 random locations around the current location within 5km
      for (int i = 0; i < 5; i++) {
        LatLng randomLocation = _generateRandomLocation(_currentLocation!, 5);
        randomLocations.add(randomLocation);
        randomMarkers.add(Marker(
          markerId: MarkerId('random_location_$i'),
          position: randomLocation,
          infoWindow: InfoWindow(title: 'Destination $i'),
          onTap: () {
            _onMarkerTapped(randomLocation);
          },
        ));
      }
    });
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

  // Fetch route from Directions API and draw polyline
  Future<void> _getDirections(LatLng destination) async {
    final String url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${_currentLocation!.latitude},${_currentLocation!.longitude}&destination=${destination.latitude},${destination.longitude}&key=$googleAPIKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      // Extract polyline from response
      if (data['routes'] != null && data['routes'].length > 0) {
        final polylinePoints = data['routes'][0]['overview_polyline']['points'];
        final polylineCoordinates = _decodePoly(polylinePoints);

        setState(() {
          // Clear previous polylines
          _polylines.clear();
          _polylines.add(Polyline(
            polylineId: PolylineId('route'),
            points: polylineCoordinates,
            color: Colors.blue,
            width: 5,
          ));
        });
      }
    } else {
      throw Exception('Failed to load directions');
    }
  }

  // Decode polyline points from the Directions API response
  List<LatLng> _decodePoly(String poly) {
    List<LatLng> polyline = [];
    int index = 0;
    int len = poly.length;
    int lat = 0;
    int lng = 0;

    while (index < len) {
      int shift = 0;
      int result = 0;

      // Decode latitude
      do {
        int byte = poly.codeUnitAt(index) - 63;
        result |= (byte & 0x1f) << shift;
        shift += 5;
        index++;
      } while (poly.codeUnitAt(index - 1) >= 0x20);

      int dlat = (result & 0x1) != 0 ? ~(result >> 1) : (result >> 1);
      lat += dlat;

      shift = 0;
      result = 0;

      // Decode longitude
      do {
        int byte = poly.codeUnitAt(index) - 63;
        result |= (byte & 0x1f) << shift;
        shift += 5;
        index++;
      } while (poly.codeUnitAt(index - 1) >= 0x20);

      int dlng = (result & 0x1) != 0 ? ~(result >> 1) : (result >> 1);
      lng += dlng;

      polyline.add(LatLng(lat / 1E5, lng / 1E5));
    }

    return polyline;
  }

  // On tapping a marker, show the route to the selected destination
  void _onMarkerTapped(LatLng destination) {
    setState(() {
      selectedDestination = destination;
    });
    _getDirections(destination);
    _controller?.moveCamera(CameraUpdate.newLatLng(destination)); // Move the camera to the selected destination
  }

  // Show Bottom Sheet to select destination
  void _showDestinationList() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 400,
          child: ListView.builder(
            itemCount: randomLocations.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text('Destination ${index + 1}'),
                onTap: () {
                  Navigator.pop(context); // Close the bottom sheet
                  setState(() {
                    selectedDestination = randomLocations[index];
                  });
                  // Remove previous markers, add selected one, and show route
                  _markers.add(Marker(
                    markerId: MarkerId('selected_destination'),
                    position: randomLocations[index],
                    infoWindow: InfoWindow(title: 'Selected Destination'),
                  ));
                  _getDirections(randomLocations[index]); // Get route and display polyline
                  _controller?.moveCamera(CameraUpdate.newLatLng(randomLocations[index])); // Move to the selected destination
                },
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Google Maps with Routing'),
        actions: [
          IconButton(
            icon: Icon(Icons.list),
            onPressed: _showDestinationList, // Show the Bottom Sheet when tapped
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
                  markers: _markers.union(randomMarkers.toSet()), // Show current and random markers
                  polylines: _polylines,
                ),
                Positioned(
                  top: 20,
                  left: 10,
                  right: 10,
                  child: Container(
                    color: Colors.white,
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        labelText: 'Search destination',
                        hintText: 'Enter place name or lat,lng',
                        border: OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(Icons.search),
                          onPressed: () {
                            // Search functionality (optional)
                          },
                        ),
                      ),
                    ),
                  ),
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
