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

class SSLCommerzScreen extends StatelessWidget {
  final int spotId;
  final double pricePerHour;
  final String renterId;
  final double totalAmount;
  final DateTime startTime;
  final DateTime endTime;

  const SSLCommerzScreen({
    Key? key,
    required this.spotId,
    required this.pricePerHour,
    required this.renterId,
    required this.totalAmount,
    required this.startTime,
    required this.endTime,
  }) : super(key: key);

  Future<void> _startSSLCommerzTransaction(BuildContext context) async {
    try {
      // Initialize SSLCommerz SDK
      Sslcommerz sslcommerz = Sslcommerz(
        initializer: SSLCommerzInitialization(
          sdkType: SSLCSdkType.TESTBOX,
          store_id: "parkk67bde9fc11501",
          store_passwd: "parkk67bde9fc11501@ssl",
          total_amount: totalAmount,
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
          customerName: renterId,
          customerEmail: "$renterId@example.com",
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
      _onPaymentSuccess(result, context);
      _displayPaymentStatus(result);
    } catch (e) {
      Fluttertoast.showToast(msg: "Error: $e");
    }
  }

  Future<void> _onPaymentSuccess(SSLCTransactionInfoModel result, BuildContext context) async {
    if (result.status?.toLowerCase()!="failed" && result.status?.toLowerCase()!="closed") {                                                
      // Prepare booking data to send to backend
      Map<String, dynamic> bookingData = {
        "spot_id": spotId,
        "start_time": startTime.toString(),
        "end_time": endTime.toString(),
        "amount": totalAmount,
        "renter_id": renterId,
      };

      // Call backend's create_booking API
      final response = await http.post(
        Uri.parse("http://10.0.2.2:5000/api/bookings"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(bookingData),
      );

      if (response.statusCode == 201) {
        Fluttertoast.showToast(msg: "Booking successful!");
        Navigator.pop(context);
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
      appBar: AppBar(title: Text('SSLCommerz Payment')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Amount: BDT ${totalAmount.toStringAsFixed(2)}'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _startSSLCommerzTransaction(context),
              child: Text('Proceed with Payment'),
            ),
          ],
        ),
      ),
    );
  }
}
