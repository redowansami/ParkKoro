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
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E3A8A),
        title: const Text(
          'Edit Your Listings',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1E3A8A),
              Color(0xFF3B82F6),
            ],
          ),
        ),
        child: isLoading
            ? const Center(child: CircularProgressIndicator(color: Colors.white))
            : ListView.builder(
                itemCount: parkingSpots.length,
                itemBuilder: (context, index) {
                  final spot = parkingSpots[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    color: Colors.white.withOpacity(0.9),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 3,
                    child: ListTile(
                      title: Text(
                        spot['location'],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        'Vehicle Type: ${spot['vehicle_type']} - Price: \$${spot['price']}',
                      ),
                      trailing: const Icon(Icons.edit, color: Color(0xFF1E3A8A)),
                      onTap: () => navigateToEditForm(spot),
                    ),
                  );
                },
              ),
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
    final requestBody = {
      'spot_id': widget.spot['spot_id'],
      'price': int.tryParse(_priceController.text) ?? 0,
      'cancellation_policy': _cancellationPolicy,
      'availability_status': _availabilityStatus,
    };

    print('Request Body: ${jsonEncode(requestBody)}');

    final response = await http.put(
      Uri.parse('http://10.0.2.2:5000/edit_parking_spot'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Parking spot updated successfully!')),
      );
      Navigator.pop(context);
    } else {
      print('Response Body: ${response.body}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update parking spot.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E3A8A),
        title: const Text(
          'Edit Parking Spot',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1E3A8A),
              Color(0xFF3B82F6),
            ],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            color: Colors.white.withOpacity(0.9),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 3,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _priceController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Price',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFF1E3A8A), width: 2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    DropdownButtonFormField<String>(
                      value: _cancellationPolicy,
                      decoration: InputDecoration(
                        labelText: 'Cancellation Policy',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFF1E3A8A), width: 2),
                        ),
                      ),
                      items: cancellationPolicies.map((policy) {
                        return DropdownMenuItem<String>(
                          value: policy,
                          child: Text(policy),
                        );
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
                          activeColor: const Color(0xFF1E3A8A),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: updateParkingSpot,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1E3A8A),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: const Text(
                          'Save Changes',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}