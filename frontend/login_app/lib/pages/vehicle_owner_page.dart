// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// class VehicleOwnerPage extends StatefulWidget {
//   final String username;

//   const VehicleOwnerPage({super.key, required this.username});

//   @override
//   _VehicleOwnerPageState createState() => _VehicleOwnerPageState();
// }

// class _VehicleOwnerPageState extends State<VehicleOwnerPage> {
//   List<dynamic> verifiedSpots = [];

//   // Fetch verified parking spots from the backend
//   Future<void> fetchVerifiedSpots() async {
//     try {
//       final response = await http.get(
//         Uri.parse('http://127.0.0.1:5000/verified_parking_spots'),
//       );
//       if (response.statusCode == 200) {
//         setState(() {
//           verifiedSpots = jsonDecode(response.body);
//         });
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Failed to load parking spots')),
//         );
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error: $e')),
//       );
//     }
//   }

//   // Display the list of parking spots
//   void _navigateToVerifiedSpots() {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => Scaffold(
//           appBar: AppBar(title: Text('Verified Parking Spots')),
//           body: ListView.builder(
//             itemCount: verifiedSpots.length,
//             itemBuilder: (context, index) {
//               final spot = verifiedSpots[index];
//               return Card(
//                 child: ListTile(
//                   title: Text('Spot ID: ${spot['spot_id']}'),
//                   subtitle: Text(
//                     'Address: ${spot['address']}\n'
//                     'Pricing: \$${spot['pricing']}\n'
//                     'Availability: ${spot['availability_status'] ? 'Available' : 'Not Available'}',
//                   ),
//                 ),
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   void initState() {
//     super.initState();
//     fetchVerifiedSpots(); // Fetch the verified parking spots when the page loads
//   }

//   // Widget to build sections in the page
//   Widget _buildSection(BuildContext context,
//       {required IconData icon,
//       required String title,
//       required String description,
//       required VoidCallback onTap}) {
//     return Card(
//       margin: const EdgeInsets.only(bottom: 16.0),
//       child: ListTile(
//         leading: Icon(icon, size: 40),
//         title: Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//         subtitle: Text(description),
//         trailing: Icon(Icons.arrow_forward),
//         onTap: onTap,
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Vehicle Owner Dashboard'),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.logout),
//             onPressed: () {
//               Navigator.pop(context); // Log out functionality
//             },
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Welcome, ${widget.username}!',
//               style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 20),

//             // Search Parking Spots Section
//             _buildSection(
//               context,
//               icon: Icons.search,
//               title: 'Search Parking Spots',
//               description: 'Find nearby available parking spots.',
//               onTap: _navigateToVerifiedSpots, // Navigate to the verified spots page
//             ),

//             // Reserve Spot Section
//             _buildSection(
//               context,
//               icon: Icons.bookmark_add,
//               title: 'Reserve Spot',
//               description: 'Book a parking spot for your vehicle.',
//               onTap: () {
//                 // Implement reserve spot functionality
//               },
//             ),

//             // Cancel Booking Section
//             _buildSection(
//               context,
//               icon: Icons.cancel,
//               title: 'Cancel Booking',
//               description: 'Cancel your active bookings.',
//               onTap: () {
//                 // Implement cancel booking functionality
//               },
//             ),

//             // Payment Section
//             _buildSection(
//               context,
//               icon: Icons.payment,
//               title: 'Payment',
//               description: 'Make payments for parking spots.',
//               onTap: () {
//                 // Implement payment functionality
//               },
//             ),

//             // Review Parking Spot Section
//             _buildSection(
//               context,
//               icon: Icons.rate_review,
//               title: 'Review Parking Spot',
//               description: 'Leave feedback about a parking spot.',
//               onTap: () {
//                 // Implement review functionality
//               },
//             ),

//             // Navigation Section
//             _buildSection(
//               context,
//               icon: Icons.navigation,
//               title: 'Get Navigation',
//               description: 'Access navigation to your booked spot.',
//               onTap: () {
//                 // Implement navigation functionality
//               },
//             ),

//             // Booking History Section
//             _buildSection(
//               context,
//               icon: Icons.history,
//               title: 'View Booking History',
//               description: 'See your past bookings.',
//               onTap: () {
//                 // Implement view booking history functionality
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'login_page.dart';

// class VehicleOwnerPage extends StatefulWidget {
//   final String username;
//   const VehicleOwnerPage({super.key, required this.username});

//   @override
//   _VehicleOwnerPageState createState() => _VehicleOwnerPageState();
// }

// class _VehicleOwnerPageState extends State<VehicleOwnerPage> {
//   List<dynamic> verifiedSpots = [];
//   bool _isLoading = false;

//   Future<void> fetchVerifiedSpots() async {
//     setState(() => _isLoading = true);
//     try {
//       final response = await http.get(
//         Uri.parse('http://127.0.0.1:5000/verified_parking_spots'),
//       );
//       if (response.statusCode == 200) {
//         setState(() {
//           verifiedSpots = jsonDecode(response.body);
//           _isLoading = false;
//         });
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('Failed to load parking spots'),
//             backgroundColor: Colors.red,
//             behavior: SnackBarBehavior.floating,
//           ),
//         );
//         setState(() => _isLoading = false);
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Error: $e'),
//           backgroundColor: Colors.red,
//           behavior: SnackBarBehavior.floating,
//         ),
//       );
//       setState(() => _isLoading = false);
//     }
//   }

//   void _navigateToVerifiedSpots() {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => Scaffold(
//           appBar: AppBar(
//             title: const Text('Available Parking Spots'),
//             elevation: 0,
//           ),
//           body: _isLoading
//               ? const Center(child: CircularProgressIndicator())
//               : ListView.builder(
//                   padding: const EdgeInsets.all(16.0),
//                   itemCount: verifiedSpots.length,
//                   itemBuilder: (context, index) {
//                     final spot = verifiedSpots[index];
//                     return Card(
//                       elevation: 2,
//                       margin: const EdgeInsets.only(bottom: 16.0),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       child: Padding(
//                         padding: const EdgeInsets.all(16.0),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Text(
//                                   'Spot #${spot['spot_id']}',
//                                   style: const TextStyle(
//                                     fontSize: 18,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                                 Container(
//                                   padding: const EdgeInsets.symmetric(
//                                     horizontal: 12,
//                                     vertical: 6,
//                                   ),
//                                   decoration: BoxDecoration(
//                                     color: spot['availability_status']
//                                         ? Colors.green.withOpacity(0.1)
//                                         : Colors.red.withOpacity(0.1),
//                                     borderRadius: BorderRadius.circular(20),
//                                   ),
//                                   child: Text(
//                                     spot['availability_status']
//                                         ? 'Available'
//                                         : 'Occupied',
//                                     style: TextStyle(
//                                       color: spot['availability_status']
//                                           ? Colors.green
//                                           : Colors.red,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             const SizedBox(height: 12),
//                             Row(
//                               children: [
//                                 const Icon(Icons.location_on_outlined,
//                                     color: Colors.grey),
//                                 const SizedBox(width: 8),
//                                 Expanded(
//                                   child: Text(
//                                     spot['address'],
//                                     style: const TextStyle(
//                                       fontSize: 16,
//                                       color: Colors.black87,
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             const SizedBox(height: 8),
//                             Row(
//                               children: [
//                                 const Icon(Icons.attach_money,
//                                     color: Colors.grey),
//                                 const SizedBox(width: 8),
//                                 Text(
//                                   '\$${spot['pricing']}/hour',
//                                   style: const TextStyle(
//                                     fontSize: 16,
//                                     color: Colors.black87,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             const SizedBox(height: 16),
//                             SizedBox(
//                               width: double.infinity,
//                               child: ElevatedButton(
//                                 onPressed: spot['availability_status']
//                                     ? () {
//                                         // Implement booking functionality
//                                       }
//                                     : null,
//                                 style: ElevatedButton.styleFrom(
//                                   padding: const EdgeInsets.symmetric(vertical: 12),
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(8),
//                                   ),
//                                 ),
//                                 child: const Text('Book Now'),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//         ),
//       ),
//     );
//   }

//   @override
//   void initState() {
//     super.initState();
//     fetchVerifiedSpots();
//   }

//   Widget _buildSection({
//     required IconData icon,
//     required String title,
//     required String description,
//     required VoidCallback onTap,
//     Color? iconColor,
//   }) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 16.0),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 10,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Material(
//         color: Colors.transparent,
//         child: InkWell(
//           borderRadius: BorderRadius.circular(12),
//           onTap: onTap,
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Row(
//               children: [
//                 Container(
//                   padding: const EdgeInsets.all(12),
//                   decoration: BoxDecoration(
//                     color: (iconColor ?? Theme.of(context).primaryColor).withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Icon(
//                     icon,
//                     size: 24,
//                     color: iconColor ?? Theme.of(context).primaryColor,
//                   ),
//                 ),
//                 const SizedBox(width: 16),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         title,
//                         style: const TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       const SizedBox(height: 4),
//                       Text(
//                         description,
//                         style: TextStyle(
//                           fontSize: 14,
//                           color: Colors.grey[600],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Icon(
//                   Icons.arrow_forward_ios,
//                   size: 16,
//                   color: Colors.grey[400],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[100],
//       appBar: AppBar(
//         elevation: 0,
//         title: const Text('Dashboard'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.logout),
//             onPressed: () {
//               // Replace the entire navigation stack with login page
//               Navigator.pushAndRemoveUntil(
//                 context,
//                 MaterialPageRoute(builder: (context) => const LoginPage()),
//                 (route) => false, // This will remove all routes from the stack
//               );
//             },
//           ),
//         ],
//       ),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Welcome Section
//               Container(
//                 padding: const EdgeInsets.all(20),
//                 decoration: BoxDecoration(
//                   color: Theme.of(context).primaryColor,
//                   borderRadius: BorderRadius.circular(16),
//                 ),
//                 child: Row(
//                   children: [
//                     CircleAvatar(
//                       radius: 30,
//                       backgroundColor: Colors.white.withOpacity(0.2),
//                       child: Text(
//                         widget.username[0].toUpperCase(),
//                         style: const TextStyle(
//                           fontSize: 24,
//                           color: Colors.white,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 16),
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           'Welcome back,',
//                           style: TextStyle(
//                             fontSize: 16,
//                             color: Colors.white.withOpacity(0.8),
//                           ),
//                         ),
//                         Text(
//                           widget.username,
//                           style: const TextStyle(
//                             fontSize: 24,
//                             color: Colors.white,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 24),

//               // Quick Actions Section
//               const Text(
//                 'Quick Actions',
//                 style: TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 16),

//               _buildSection(
//                 icon: Icons.search,
//                 title: 'Find Parking',
//                 description: 'Search for available spots nearby',
//                 onTap: _navigateToVerifiedSpots,
//                 iconColor: Colors.blue,
//               ),

//               _buildSection(
//                 icon: Icons.bookmark_add,
//                 title: 'Reserve Spot',
//                 description: 'Book a parking spot in advance',
//                 onTap: () {},
//                 iconColor: Colors.green,
//               ),

//               _buildSection(
//                 icon: Icons.history,
//                 title: 'Booking History',
//                 description: 'View your past parking sessions',
//                 onTap: () {},
//                 iconColor: Colors.purple,
//               ),

//               _buildSection(
//                 icon: Icons.payment,
//                 title: 'Payments',
//                 description: 'Manage your payments and wallet',
//                 onTap: () {},
//                 iconColor: Colors.orange,
//               ),

//               _buildSection(
//                 icon: Icons.star_outline,
//                 title: 'Reviews',
//                 description: 'Rate and review parking spots',
//                 onTap: () {},
//                 iconColor: Colors.amber,
//               ),

//               _buildSection(
//                 icon: Icons.support_agent,
//                 title: 'Support',
//                 description: 'Get help and contact support',
//                 onTap: () {},
//                 iconColor: Colors.teal,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'login_page.dart';

class VehicleOwnerPage extends StatefulWidget {
  final String username;
  const VehicleOwnerPage({super.key, required this.username});

  @override
  _VehicleOwnerPageState createState() => _VehicleOwnerPageState();
}

class _VehicleOwnerPageState extends State<VehicleOwnerPage> {
  List<dynamic> verifiedSpots = [];
  bool _isLoading = false;

  Future<void> fetchVerifiedSpots() async {
    setState(() => _isLoading = true);
    try {
      final response = await http.get(
        Uri.parse('http://127.0.0.1:5000/verified_parking_spots'),
      );
      if (response.statusCode == 200) {
        setState(() {
          verifiedSpots = jsonDecode(response.body);
          _isLoading = false;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to load parking spots'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
        setState(() => _isLoading = false);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
      setState(() => _isLoading = false);
    }
  }

  void _navigateToVerifiedSpots() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: const Text('Available Parking Spots'),
            elevation: 0,
          ),
          body: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: verifiedSpots.length,
                  itemBuilder: (context, index) {
                    final spot = verifiedSpots[index];
                    return Card(
                      elevation: 2,
                      margin: const EdgeInsets.only(bottom: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Spot #${spot['spot_id']}',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: spot['availability_status']
                                        ? Colors.green.withOpacity(0.1)
                                        : Colors.red.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    spot['availability_status']
                                        ? 'Available'
                                        : 'Occupied',
                                    style: TextStyle(
                                      color: spot['availability_status']
                                          ? Colors.green
                                          : Colors.red,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                const Icon(Icons.location_on_outlined,
                                    color: Colors.grey),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    spot['address'],
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(Icons.attach_money,
                                    color: Colors.grey),
                                const SizedBox(width: 8),
                                Text(
                                  '\$${spot['pricing']}/hour',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: spot['availability_status']
                                    ? () {
                                        // Implement booking functionality
                                      }
                                    : null,
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text('Book Now'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    fetchVerifiedSpots();
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color? iconColor,
  }) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(50),
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: (iconColor ?? Theme.of(context).primaryColor).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 40,
              color: iconColor ?? Theme.of(context).primaryColor,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // Replace the entire navigation stack with login page
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
                (route) => false, // This will remove all routes from the stack
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Section
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.white.withOpacity(0.2),
                      child: Text(
                        widget.username[0].toUpperCase(),
                        style: const TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome back,',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                        Text(
                          widget.username,
                          style: const TextStyle(
                            fontSize: 24,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Quick Actions Section
              const Text(
                'Quick Actions',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              // Grid of Quick Actions
              GridView.count(
                crossAxisCount: 3,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildActionButton(
                    icon: Icons.search,
                    label: 'Find Parking',
                    onTap: _navigateToVerifiedSpots,
                    iconColor: Colors.blue,
                  ),
                  _buildActionButton(
                    icon: Icons.bookmark_add,
                    label: 'Reserve Spot',
                    onTap: () {},
                    iconColor: Colors.green,
                  ),
                  _buildActionButton(
                    icon: Icons.history,
                    label: 'History',
                    onTap: () {},
                    iconColor: Colors.purple,
                  ),
                  _buildActionButton(
                    icon: Icons.payment,
                    label: 'Payments',
                    onTap: () {},
                    iconColor: Colors.orange,
                  ),
                  _buildActionButton(
                    icon: Icons.star_outline,
                    label: 'Reviews',
                    onTap: () {},
                    iconColor: Colors.amber,
                  ),
                  _buildActionButton(
                    icon: Icons.support_agent,
                    label: 'Support',
                    onTap: () {},
                    iconColor: Colors.teal,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}