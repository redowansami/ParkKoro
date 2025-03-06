// import 'package:flutter/material.dart';
// import '../../controllers/parking_spot_controller.dart';
// import '../../models/parking_spot.dart';

// class AddListingScreen extends StatefulWidget {
//   final String username;

//   const AddListingScreen({super.key, required this.username});

//   @override
//   _AddListingScreenState createState() => _AddListingScreenState();
// }

// class _AddListingScreenState extends State<AddListingScreen> {
//   final ParkingSpotController _controller = ParkingSpotController();
//   late ParkingSpot _model;

//   @override
//   void initState() {
//     super.initState();
//     _model = ParkingSpot(
//       spotID: '',
//       ownerID: widget.username,
//       adminID: null,
//       vehicleType: '',
//       location: '',
//       gpsCoordinates: '',
//       price: 0,
//       evCharging: false,
//       surveillance: false,
//       cancellationPolicy: 'Strict',
//       availabilityStatus: true,
//     );
//   }

//   Future<void> _submitParkingSpot() async {
//     try {
//       await _controller.submitParkingSpot(_model);
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Parking spot submitted for review.')),
//       );
//       setState(() {
//         _model.spotID = '';
//         _model.gpsCoordinates = '';
//         _model.location = '';
//         _model.price = 0;
//         _model.evCharging = false;
//         _model.surveillance = false;
//         _model.vehicleType = '';
//         _model.cancellationPolicy = 'Strict';
//       });
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error: $e')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Register Parking Space'),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(
//               onChanged: (value) => _model.spotID = value,
//               decoration: const InputDecoration(labelText: 'Spot ID'),
//             ),
//             TextField(
//               onChanged: (value) => _model.gpsCoordinates = value,
//               decoration: const InputDecoration(labelText: 'GPS Coordinates'),
//             ),
//             TextField(
//               onChanged: (value) => _model.location = value,
//               decoration: const InputDecoration(labelText: 'Location'),
//             ),
//             TextField(
//               onChanged: (value) => _model.price = int.parse(value),
//               decoration: const InputDecoration(labelText: 'Price'),
//               keyboardType: TextInputType.number,
//             ),
//             TextField(
//               onChanged: (value) => _model.vehicleType = value,
//               decoration: const InputDecoration(labelText: 'Vehicle Type'),
//             ),
//             Row(
//               children: [
//                 const Text('EV Charging'),
//                 Switch(
//                   value: _model.evCharging,
//                   onChanged: (value) {
//                     setState(() {
//                       _model.evCharging = value;
//                     });
//                   },
//                 ),
//               ],
//             ),
//             Row(
//               children: [
//                 const Text('Surveillance'),
//                 Switch(
//                   value: _model.surveillance,
//                   onChanged: (value) {
//                     setState(() {
//                       _model.surveillance = value;
//                     });
//                   },
//                 ),
//               ],
//             ),
//             DropdownButton<String>(
//               value: _model.cancellationPolicy,
//               onChanged: (String? newValue) {
//                 setState(() {
//                   _model.cancellationPolicy = newValue!;
//                 });
//               },
//               items: <String>['Strict', 'Moderate', 'Flexible']
//                   .map<DropdownMenuItem<String>>((String value) {
//                 return DropdownMenuItem<String>(
//                   value: value,
//                   child: Text(value),
//                 );
//               }).toList(),
//             ),
//             ElevatedButton(
//               onPressed: _submitParkingSpot,
//               child: const Text('Submit'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import '../../controllers/parking_spot_controller.dart';
import '../../models/parking_spot.dart';

class AddListingScreen extends StatefulWidget {
  final String username;

  const AddListingScreen({super.key, required this.username});

  @override
  _AddListingScreenState createState() => _AddListingScreenState();
}

class _AddListingScreenState extends State<AddListingScreen> {
  final ParkingSpotController _controller = ParkingSpotController();
  late ParkingSpot _model;

  @override
  void initState() {
    super.initState();
    _model = ParkingSpot(
      spotID: 0,  // Integer spotID
      ownerID: widget.username,
      adminID: null,
      vehicleType: '',
      location: '',
      latitude: 0.0,  // Initialize latitude
      longitude: 0.0,  // Initialize longitude
      price: 0,
      evCharging: false,
      surveillance: false,
      cancellationPolicy: 'Strict',
      availabilityStatus: true,
    );
  }

  Future<void> _submitParkingSpot() async {
    try {
      await _controller.submitParkingSpot(_model);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Parking spot submitted for review.')),
      );
      setState(() {
        _model.spotID = 0;
        _model.latitude = 0.0;
        _model.longitude = 0.0;
        _model.location = '';
        _model.price = 0;
        _model.evCharging = false;
        _model.surveillance = false;
        _model.vehicleType = '';
        _model.cancellationPolicy = 'Strict';
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register Parking Space'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              onChanged: (value) => _model.location = value,
              decoration: const InputDecoration(labelText: 'Location'),
            ),
            TextField(
              onChanged: (value) => _model.latitude = double.tryParse(value) ?? 0.0,
              decoration: const InputDecoration(labelText: 'Latitude'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              onChanged: (value) => _model.longitude = double.tryParse(value) ?? 0.0,
              decoration: const InputDecoration(labelText: 'Longitude'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              onChanged: (value) => _model.price = int.parse(value),
              decoration: const InputDecoration(labelText: 'Price'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              onChanged: (value) => _model.vehicleType = value,
              decoration: const InputDecoration(labelText: 'Vehicle Type'),
            ),
            Row(
              children: [
                const Text('EV Charging'),
                Switch(
                  value: _model.evCharging,
                  onChanged: (value) {
                    setState(() {
                      _model.evCharging = value;
                    });
                  },
                ),
              ],
            ),
            Row(
              children: [
                const Text('Surveillance'),
                Switch(
                  value: _model.surveillance,
                  onChanged: (value) {
                    setState(() {
                      _model.surveillance = value;
                    });
                  },
                ),
              ],
            ),
            DropdownButton<String>(
              value: _model.cancellationPolicy,
              onChanged: (String? newValue) {
                setState(() {
                  _model.cancellationPolicy = newValue!;
                });
              },
              items: <String>['Strict', 'Moderate', 'Flexible']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            ElevatedButton(
              onPressed: _submitParkingSpot,
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
