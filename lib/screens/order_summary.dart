import 'package:flutter/material.dart';

class OrderSummaryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Retrieving the arguments passed from the CardPaymentPage
    final Map<String, dynamic> orderDetails =
    ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;

    final room = orderDetails['room'];
    final date = orderDetails['date'];
    final timeSlot = orderDetails['timeSlot'];
    final amount = orderDetails['amount'];

    return Scaffold(
      appBar: AppBar(
        title: Text('Order Summary'),
        backgroundColor: Colors.indigo,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center( // Center the container
          child: Container(
            padding: const EdgeInsets.all(20.0), // Keep inner padding
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min, // Make the column size fit its content
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Booking Details',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text('Room: ${room['name']}'),
                SizedBox(height: 10),
                Text('Date: $date'),
                SizedBox(height: 10),
                Text('Time Slot: $timeSlot'),
                SizedBox(height: 10),
                Text('Amount Paid: \$${amount.toStringAsFixed(2)}'),
                SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () {
                    // Navigate back to home or another page
                    Navigator.popUntil(context, ModalRoute.withName('/'));
                  },
                  child: Text('Home'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo[100]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
