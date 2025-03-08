
import 'package:flutter/material.dart';
import 'package:login_app/View/sslcommerz_screen.dart';

class BookingScreen extends StatefulWidget {
  final int spotId;
  final double pricePerHour;
  final String renterId;

  const BookingScreen({
    Key? key,
    required this.spotId,
    required this.pricePerHour,
    required this.renterId,
  }) : super(key: key);

  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
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
    return "${dateTime.year}-${_twoDigits(dateTime.month)}-${_twoDigits(dateTime.day)} "
        "${_twoDigits(dateTime.hour)}:${_twoDigits(dateTime.minute)}";
  }

  String _twoDigits(int n) {
    return n.toString().padLeft(2, '0');
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
              onPressed: _startTime != null && _endTime != null
                  ? () {
                      // Navigate to the SSLCommerz screen with booking details
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SSLCommerzScreen(
                            spotId: widget.spotId,
                            pricePerHour: widget.pricePerHour,
                            renterId: widget.renterId,
                            totalAmount: _totalAmount,
                            startTime: _startTime!,
                            endTime: _endTime!,
                          ),
                        ),
                      );
                    }
                  : null,
              child: Text('Confirm Booking & Pay'),
            ),
          ],
        ),
      ),
    );
  }
}
