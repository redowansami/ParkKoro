// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class EditListingScreen extends StatefulWidget {
//   final String username;

//   const EditListingScreen({super.key, required this.username});

//   @override
//   _EditListingScreenState createState() => _EditListingScreenState();
// }

// class _EditListingScreenState extends State<EditListingScreen> {
//   List<Map<String, dynamic>> parkingSpots = [];
//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     fetchParkingSpots();
//   }

//   Future<void> fetchParkingSpots() async {
//     final response = await http.post(
//       Uri.parse('http://10.0.2.2:5000/get_parking_spots'),
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode({'owner_id': widget.username}),
//     );

//     if (response.statusCode == 200) {
//       setState(() {
//         parkingSpots = List<Map<String, dynamic>>.from(jsonDecode(response.body));
//         isLoading = false;
//       });
//     } else {
//       setState(() {
//         isLoading = false;
//       });
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to load parking spots.')),
//       );
//     }
//   }

//   void navigateToEditForm(Map<String, dynamic> spot) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => EditSpotForm(spot: spot),
//       ),
//     ).then((_) => fetchParkingSpots());
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Edit Your Listings')),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : ListView.builder(
//               itemCount: parkingSpots.length,
//               itemBuilder: (context, index) {
//                 final spot = parkingSpots[index];
//                 return ListTile(
//                   title: Text(spot['location']),
//                   subtitle: Text('Vehicle Type: ${spot['vehicle_type']} - Price: \$${spot['price']}'),
//                   trailing: const Icon(Icons.edit),
//                   onTap: () => navigateToEditForm(spot),
//                 );
//               },
//             ),
//     );
//   }
// }

// class EditSpotForm extends StatefulWidget {
//   final Map<String, dynamic> spot;

//   const EditSpotForm({super.key, required this.spot});

//   @override
//   _EditSpotFormState createState() => _EditSpotFormState();
// }

// class _EditSpotFormState extends State<EditSpotForm> {
//   final _formKey = GlobalKey<FormState>();
//   late TextEditingController _locationController;
//   late TextEditingController _priceController;
//   late TextEditingController _vehicleTypeController;

//   @override
//   void initState() {
//     super.initState();
//     _locationController = TextEditingController(text: widget.spot['location']);
//     _priceController = TextEditingController(text: widget.spot['price'].toString());
//     _vehicleTypeController = TextEditingController(text: widget.spot['vehicle_type']);
//   }

//   Future<void> updateParkingSpot() async {
//     final response = await http.put(
//       Uri.parse('http://10.0.2.2:5000/edit_parking_spot'),
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode({
//         'spot_id': widget.spot['spot_id'],
//         'owner_id': widget.spot['owner_id'],
//         'location': _locationController.text,
//         'price': double.tryParse(_priceController.text) ?? 0.0,
//         'vehicle_type': _vehicleTypeController.text,
//       }),
//     );

//     if (response.statusCode == 200) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Parking spot updated successfully!')),
//       );
//       Navigator.pop(context);
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to update parking spot.')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Edit Parking Spot')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             children: [
//               TextFormField(
//                 controller: _locationController,
//                 decoration: const InputDecoration(labelText: 'Location'),
//               ),
//               TextFormField(
//                 controller: _vehicleTypeController,
//                 decoration: const InputDecoration(labelText: 'Vehicle Type'),
//               ),
//               TextFormField(
//                 controller: _priceController,
//                 keyboardType: TextInputType.number,
//                 decoration: const InputDecoration(labelText: 'Price'),
//               ),
//               const SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: updateParkingSpot,
//                 child: const Text('Save Changes'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EditListingScreen extends StatefulWidget {
  final String username;

  const EditListingScreen({super.key, required this.username});

  @override
  _EditListingScreenState createState() => _EditListingScreenState();
}

class _EditListingScreenState extends State<EditListingScreen> {
  List<Map<String, dynamic>> parkingSpots = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchParkingSpots();
  }

  Future<void> fetchParkingSpots() async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:5000/get_parking_spots'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'owner_id': widget.username}),
    );

    if (response.statusCode == 200) {
      setState(() {
        parkingSpots = List<Map<String, dynamic>>.from(jsonDecode(response.body));
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load parking spots.')),
      );
    }
  }

  void navigateToEditForm(Map<String, dynamic> spot) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditSpotForm(spot: spot),
      ),
    ).then((_) => fetchParkingSpots());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Your Listings')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: parkingSpots.length,
              itemBuilder: (context, index) {
                final spot = parkingSpots[index];
                return ListTile(
                  title: Text(spot['location']),
                  subtitle: Text('Vehicle Type: ${spot['vehicle_type']} - Price: \$${spot['price']}'),
                  trailing: const Icon(Icons.edit),
                  onTap: () => navigateToEditForm(spot),
                );
              },
            ),
    );
  }
}

class EditSpotForm extends StatefulWidget {
  final Map<String, dynamic> spot;

  const EditSpotForm({super.key, required this.spot});

  @override
  _EditSpotFormState createState() => _EditSpotFormState();
}

class _EditSpotFormState extends State<EditSpotForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _priceController;
  late String _cancellationPolicy;
  late bool _availabilityStatus;

  final List<String> cancellationPolicies = ['Strict', 'Moderate', 'Flexible'];

  @override
  void initState() {
    super.initState();
    _priceController = TextEditingController(text: widget.spot['price'].toString());
    _cancellationPolicy = widget.spot['cancellation_policy'];
    _availabilityStatus = widget.spot['availability_status'];
  }

  Future<void> updateParkingSpot() async {
  // Prepare the JSON body
  final requestBody = {
    'spot_id': widget.spot['spot_id'],
    'price': int.tryParse(_priceController.text) ?? 0,
    'cancellation_policy': _cancellationPolicy,
    'availability_status': _availabilityStatus,
  };

  // Print the JSON body for debugging
  print('Request Body: ${jsonEncode(requestBody)}');

  // Make the HTTP PUT request
  final response = await http.put(
    Uri.parse('http://10.0.2.2:5000/edit_parking_spot'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(requestBody),
  );

  // Check if the request was successful
  if (response.statusCode == 200) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Parking spot updated successfully!')),
    );
    Navigator.pop(context);
  } else {
    // Print the response body if the request fails
    print('Response Body: ${response.body}');

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to update parking spot.')),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Parking Spot')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Price'),
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _cancellationPolicy,
                decoration: const InputDecoration(labelText: 'Cancellation Policy'),
                items: cancellationPolicies.map((policy) {
                  return DropdownMenuItem<String>(value: policy, child: Text(policy));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _cancellationPolicy = value!;
                  });
                },
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Text('Availability: '),
                  Switch(
                    value: _availabilityStatus,
                    onChanged: (value) {
                      setState(() {
                        _availabilityStatus = value;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: updateParkingSpot,
                child: const Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
