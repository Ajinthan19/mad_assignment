import 'package:flutter/material.dart';
import 'card_payment_page.dart'; // Import the Card Payment Page

class PaymentPage extends StatelessWidget {
  final Map<String, dynamic> room;
  final String date;
  final String timeSlot;
  final String userName; // Added userName parameter

  PaymentPage({
    Key? key,
    required this.room,
    required this.date,
    required this.timeSlot,
    required this.userName, // Accept userName in constructor
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Convert pricePerHour to double
    final totalAmount = (room['pricePerHour'] as num).toDouble(); // Ensure this is a double

    return Scaffold(
      appBar: AppBar(
        title: Text('Payment'),
        backgroundColor: Colors.indigo,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Room Details:',
              style: TextStyle(fontSize: 18, color: Colors.indigo[900]),
            ),
            SizedBox(height: 10),
            Text('Room Name: ${room['name']}'),
            Text('Capacity: ${room['capacity']}'),
            Text('Price per hour: \$${room['pricePerHour']}'),
            SizedBox(height: 20),
            Text(
              'Booking Details:',
              style: TextStyle(fontSize: 18, color: Colors.indigo[900]),
            ),
            SizedBox(height: 10),
            Text('Date: $date'),
            Text('Time Slot: $timeSlot'),
            SizedBox(height: 20),
            Text(
              'Total Amount: \$${totalAmount}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                // Navigate to the Card Payment Page without order summary navigation
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CardPaymentPage(
                      amount: totalAmount,
                      room: room,
                      date: date,
                      timeSlot: timeSlot,
                    ),
                  ),
                );
              },
              child: Text('Pay Now'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo),
            ),
          ],
        ),
      ),
    );
  }
}
