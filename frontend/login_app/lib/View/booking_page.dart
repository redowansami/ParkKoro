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
import 'package:http/http.dart' as http;
import 'dart:convert';

class BookingPage extends StatefulWidget {
  final String spotId;
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

  Future<void> _bookNow() async {
    if (_startTime == null || _endTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select both start and end times')),
      );
      return;
    }

    final response = await http.post(
      Uri.parse('http://127.0.0.1:5000/api/bookings'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        'spot_id': widget.spotId,
        'start_time': _startTime!.toIso8601String(),
        'end_time': _endTime!.toIso8601String(),
        'amount': _totalAmount, // Send payment amount
        'renter_id': widget.renterId,  // Include renter_id
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Booking confirmed! ID: ${data['booking_id']}')),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Booking failed: ${data['message']}')),
      );
    }
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
              onPressed: _bookNow,
              child: Text('Confirm Booking & Pay'),
            ),
          ],
        ),
      ),
    );
  }
}
