// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class BookingPage extends StatefulWidget {
//   final String spotId;
//   final double pricePerHour;

//   const BookingPage({Key? key, required this.spotId, required this.pricePerHour}) : super(key: key);

//   @override
//   _BookingPageState createState() => _BookingPageState();
// }

// class _BookingPageState extends State<BookingPage> {
//   DateTime? _startTime;
//   DateTime? _endTime;
//   String _duration = '';
//   double _totalAmount = 0.0;

//   Future<void> _selectDateTime(BuildContext context, bool isStart) async {
//     final DateTime? pickedDate = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime.now(),
//       lastDate: DateTime(2101),
//     );

//     if (pickedDate != null) {
//       final TimeOfDay? pickedTime = await showTimePicker(
//         context: context,
//         initialTime: TimeOfDay.now(),
//       );

//       if (pickedTime != null) {
//         final DateTime selectedDateTime = DateTime(
//           pickedDate.year,
//           pickedDate.month,
//           pickedDate.day,
//           pickedTime.hour,
//           pickedTime.minute,
//         );

//         setState(() {
//           if (isStart) {
//             _startTime = selectedDateTime;
//           } else {
//             _endTime = selectedDateTime;
//           }

//           // Calculate duration if both times are selected
//           if (_startTime != null && _endTime != null) {
//             final duration = _endTime!.difference(_startTime!);
//             final hours = duration.inHours + (duration.inMinutes % 60) / 60.0;
//             _duration = '${duration.inHours} hours, ${duration.inMinutes % 60} minutes';
//             _totalAmount = hours * widget.pricePerHour;
//           }
//         });
//       }
//     }
//   }

//   String formatDateTime(DateTime dateTime) {
//     // Manually format date and time
//     return "${dateTime.year}-${_twoDigits(dateTime.month)}-${_twoDigits(dateTime.day)} "
//         "${_twoDigits(dateTime.hour)}:${_twoDigits(dateTime.minute)}";
//   }

//   String _twoDigits(int n) {
//     return n.toString().padLeft(2, '0'); // Ensures single digits are formatted as "09" instead of "9"
//   }

//   Future<void> _bookNow() async {
//     if (_startTime == null || _endTime == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Please select both start and end times')),
//       );
//       return;
//     }

//     final response = await http.post(
//       Uri.parse('http://127.0.0.1:5000/api/bookings'),
//       headers: {"Content-Type": "application/json"},
//       body: jsonEncode({
//         'spot_id': widget.spotId,
//         'start_time': _startTime!.toIso8601String(),
//         'end_time': _endTime!.toIso8601String(),
//         'amount': _totalAmount, // Send payment amount
//       }),
//     );

//     final data = jsonDecode(response.body);

//     if (response.statusCode == 201) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Booking confirmed! ID: ${data['booking_id']}')),
//       );
//       Navigator.pop(context);
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Booking failed: ${data['message']}')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Book Parking Spot')),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text('Select Start Time:'),
//             TextButton(
//               onPressed: () => _selectDateTime(context, true),
//               child: Text(_startTime == null ? 'Choose Start Time' : formatDateTime(_startTime!)),
//             ),
//             SizedBox(height: 20),
//             Text('Select End Time:'),
//             TextButton(
//               onPressed: () => _selectDateTime(context, false),
//               child: Text(_endTime == null ? 'Choose End Time' : formatDateTime(_endTime!)),
//             ),
//             SizedBox(height: 20),
//             Text('Duration: $_duration'),
//             SizedBox(height: 10),
//             Text('Total Amount: \$${_totalAmount.toStringAsFixed(2)}'),
//             SizedBox(height: 30),
//             ElevatedButton(
//               onPressed: _bookNow,
//               child: Text('Confirm Booking & Pay'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_sslcommerz/model/SSLCCustomerInfoInitializer.dart';
import 'package:flutter_sslcommerz/model/SSLCSdkType.dart';
import 'package:flutter_sslcommerz/model/SSLCShipmentInfoInitializer.dart';
import 'package:flutter_sslcommerz/model/SSLCTransactionInfoModel.dart';
import 'package:flutter_sslcommerz/model/SSLCommerzInitialization.dart';
import 'package:flutter_sslcommerz/model/SSLCurrencyType.dart';
import 'package:flutter_sslcommerz/sslcommerz.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BookingPage extends StatefulWidget {
  final int spotId;
  final double pricePerHour;
  final String renterId;  // Added renterId

  const BookingPage({
    Key? key,
    required this.spotId,
    required this.pricePerHour,
    required this.renterId,  // Accept renterId
  }) : super(key: key);

  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  DateTime? _startTime;
  DateTime? _endTime;
  String _duration = '';
  double _totalAmount = 0.0;

  Future<void> _selectDateTime(BuildContext context, bool isStart) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        final DateTime selectedDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        setState(() {
          if (isStart) {
            _startTime = selectedDateTime;
          } else {
            _endTime = selectedDateTime;
          }

          // Calculate duration if both times are selected
          if (_startTime != null && _endTime != null) {
            final duration = _endTime!.difference(_startTime!);
            final hours = duration.inHours + (duration.inMinutes % 60) / 60.0;
            _duration = '${duration.inHours} hours, ${duration.inMinutes % 60} minutes';
            _totalAmount = hours * widget.pricePerHour;
          }
        });
      }
    }
  }

  String formatDateTime(DateTime dateTime) {
    // Manually format date and time
    return "${dateTime.year}-${_twoDigits(dateTime.month)}-${_twoDigits(dateTime.day)} "
        "${_twoDigits(dateTime.hour)}:${_twoDigits(dateTime.minute)}";
  }

  String _twoDigits(int n) {
    return n.toString().padLeft(2, '0'); // Ensures single digits are formatted as "09" instead of "9"
  }

// Future<void> _bookNow() async {
//   if (_startTime == null || _endTime == null) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('Please select both start and end times')),
//     );
//     return;
//   }

//   // Get vehicle owner information
//   final vehicleOwner = {
//     'username': widget.renterId,  // Assuming renterId is the vehicle owner's username
//     'email': 'owner@example.com',  // Vehicle owner's email (use actual data)
//     'phone': '017XXXXXXXX',  // Vehicle owner's phone (use actual data)
//     'carType': 'Sedan',  // Vehicle type (use actual data)
//     'licensePlate': 'XYZ 1234',  // License plate number (use actual data)
//     'drivingLicense': 'DL12345',  // Driving license number (use actual data)
//     'userType': 'owner',  // Assuming 'owner' user type (use actual data)
//   };

//   final response = await http.post(
//     Uri.parse('http://127.0.0.1:5000/api/bookings'),
//     headers: {"Content-Type": "application/json"},
//     body: jsonEncode({
//       'spot_id': widget.spotId,
//       'start_time': _startTime!.toIso8601String(),
//       'end_time': _endTime!.toIso8601String(),
//       'amount': _totalAmount,
//       'renter_id': widget.renterId,  // Include renter_id
//     }),
//   );

//   final data = jsonDecode(response.body);

//   if (response.statusCode == 201) {
//     // After booking is successful, trigger SSLCommerz payment
//     final paymentResponse = await http.post(
//       Uri.parse('http://127.0.0.1:5000/api/payments/sslcommerz'),
//       headers: {"Content-Type": "application/json"},
//       body: jsonEncode({
//         'booking_id': data['booking_id'],
//         'amount': _totalAmount,
//         'vehicle_owner': vehicleOwner,  // Pass the vehicle_owner data
//       }),
//     );

//     final paymentData = jsonDecode(paymentResponse.body);

//     if (paymentResponse.statusCode == 201) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Booking confirmed! ID: ${data['booking_id']}')),
//       );
//       Navigator.pop(context);
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Payment failed: ${paymentData['message']}')),
//       );
//     }
//   } else {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('Booking failed: ${data['message']}')),
//     );
//   }
// }

Future<void> _startSSLCommerzTransaction() async {
    try {
      // Initialize SSLCommerz SDK
      Sslcommerz sslcommerz = Sslcommerz(
        initializer: SSLCommerzInitialization(
          sdkType: SSLCSdkType.TESTBOX, 
          store_id: "parkk67bde9fc11501",
          store_passwd: "parkk67bde9fc11501@ssl", 
          total_amount: _totalAmount, 
          tran_id: DateTime.now().millisecondsSinceEpoch.toString(), 
          currency: SSLCurrencyType.BDT,
          product_category: "Service",
          multi_card_name: "visa,master,bkash",
        ),
      );

      // Adding Shipment Information
      sslcommerz.addShipmentInfoInitializer(
        sslcShipmentInfoInitializer: SSLCShipmentInfoInitializer(
          shipmentMethod: "yes",
          numOfItems: 1,
          shipmentDetails: ShipmentDetails(
            shipAddress1: "123 Main Street",
            shipCity: "Dhaka",
            shipCountry: "Bangladesh",
            shipName: "ParkKoro",
            shipPostCode: "1200",
          ),
        ),
      );

      // Adding Customer Information
      sslcommerz.addCustomerInfoInitializer(
        customerInfoInitializer: SSLCCustomerInfoInitializer(
          customerName: widget.renterId,
          customerEmail: "${widget.renterId}@example.com",
          customerAddress1: "123 Main Street",
          customerCity: "Dhaka",
          customerPostCode: "1200",
          customerCountry: "Bangladesh",
          customerPhone: "017XXXXXXXX", 
          customerState: 'D1',
        ),
      );

      // Initiating Payment
      SSLCTransactionInfoModel result = await sslcommerz.payNow();
      _onPaymentSuccess(result);
      // Displaying the payment result
      _displayPaymentStatus(result);
    } catch (e) {
      Fluttertoast.showToast(msg: "Error: $e");
    }
  }

  Future<void> _onPaymentSuccess(SSLCTransactionInfoModel result) async {
  if (result.status == "VALID") {
    // Prepare booking data to send to backend
    Map<String, dynamic> bookingData = {
      "spot_id": widget.spotId,
      "start_time": _startTime.toString(),
      "end_time": _endTime.toString(),
      "amount": _totalAmount,
      "renter_id": widget.renterId,
      "transaction_id": result.tranId, // Get from SSLCommerz
    };

    // Call backend's create_booking API
    final response = await http.post(
      Uri.parse("https://127.0.0.1/api/create_booking"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(bookingData),
    );

    if (response.statusCode == 201) {
      Fluttertoast.showToast(msg: "Booking successful!");
    } else {
      Fluttertoast.showToast(msg: "Booking failed: ${response.body}");
    }
  } else {
    Fluttertoast.showToast(msg: "Payment validation failed.");
  }
}

  // Function to display payment status
  void _displayPaymentStatus(SSLCTransactionInfoModel result) {
    String message;
    Color bgColor;

    switch (result.status?.toLowerCase()) {
      case "failed":
        message = "Transaction Failed";
        bgColor = Colors.red;
        break;
      case "closed":
        message = "SDK Closed by User";
        bgColor = Colors.orange;
        break;
      default:
        message = "Transaction ${result.status} - Amount: ${result.amount ?? 0}";
        bgColor = Colors.green;
    }

    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      backgroundColor: bgColor,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Book Parking Spot')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Select Start Time:'),
            TextButton(
              onPressed: () => _selectDateTime(context, true),
              child: Text(_startTime == null ? 'Choose Start Time' : formatDateTime(_startTime!)),
            ),
            SizedBox(height: 20),
            Text('Select End Time:'),
            TextButton(
              onPressed: () => _selectDateTime(context, false),
              child: Text(_endTime == null ? 'Choose End Time' : formatDateTime(_endTime!)),
            ),
            SizedBox(height: 20),
            Text('Duration: $_duration'),
            SizedBox(height: 10),
            Text('Total Amount: \$${_totalAmount.toStringAsFixed(2)}'),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: _startSSLCommerzTransaction,
              child: Text('Confirm Booking & Pay'),
            ),
          ],
        ),
      ),
    );
  }
}
