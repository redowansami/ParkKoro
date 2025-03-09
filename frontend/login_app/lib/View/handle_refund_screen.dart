import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HandleRefundScreen extends StatefulWidget {
  @override
  _HandleRefundScreenState createState() => _HandleRefundScreenState();
}

class _HandleRefundScreenState extends State<HandleRefundScreen> {
  List<dynamic> refundRequests = [];

  @override
  void initState() {
    super.initState();
    fetchRefundRequests();
  }

  // Fetch refund requests from the backend
  fetchRefundRequests() async {
    final response = await http.get(Uri.parse('http://10.0.2.2:5000/api/admin/refund_requests'));

    if (response.statusCode == 200) {
      setState(() {
        refundRequests = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load refund requests');
    }
  }

  // Update the refund status
  updateRefundStatus(int refundId, String newStatus) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:5000/api/admin/update_refund_status'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'refund_id': refundId, 'refund_status': newStatus}),
    );

    if (response.statusCode == 200) {
      fetchRefundRequests(); 
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Refund status updated successfully')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update status')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Handle Refund Requests'),
      ),
      body: ListView.builder(
        itemCount: refundRequests.length,
        itemBuilder: (context, index) {
          var request = refundRequests[index];
          bool isHandled = request['refund_status'] == 'Completed' || request['refund_status'] == 'Failed';

          return Card(
            margin: EdgeInsets.all(10),
            child: ListTile(
              title: Text('Refund ID: ${request['refund_id']}'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Booking ID: ${request['booking_id']}'),
                  Text('Renter ID: ${request['renter_id']}'),
                  Text('Amount: ${request['amount']}'),
                  Text('Refund Status: ${request['refund_status']}'),
                ],
              ),
              trailing: isHandled
                  ? ElevatedButton(
                      onPressed: null, 
                      child: Text('Handled'),
                    )
                  : ElevatedButton(
                      onPressed: () {
                        String newStatus = 'Completed'; 
                        updateRefundStatus(request['refund_id'], newStatus);
                      },
                      child: Text('Mark as Handled'),
                    ),
            ),
          );
        },
      ),
    );
  }
}