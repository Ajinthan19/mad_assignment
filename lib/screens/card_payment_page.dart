import 'package:flutter/material.dart';

class CardPaymentPage extends StatefulWidget {
  final double amount; // Total amount to be paid
  final Map<String, dynamic> room; // Room details
  final String date; // Booking date
  final String timeSlot; // Selected time slot

  CardPaymentPage({
    required this.amount,
    required this.room,
    required this.date,
    required this.timeSlot,
  });

  @override
  _CardPaymentPageState createState() => _CardPaymentPageState();
}

class _CardPaymentPageState extends State<CardPaymentPage> {
  final _cardNumberController = TextEditingController();
  final _expiryDateController = TextEditingController();
  final _cvvController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Card Payment'),
        backgroundColor: Colors.indigo,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Enter your card details',
              style: TextStyle(fontSize: 18, color: Colors.indigo[900]),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _cardNumberController,
              decoration: InputDecoration(
                labelText: 'Card Number',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _expiryDateController,
                    decoration: InputDecoration(
                      labelText: 'Expiry Date (MM/YY)',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.datetime,
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _cvvController,
                    decoration: InputDecoration(
                      labelText: 'CVV',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    obscureText: true,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              'Total Amount: \$${widget.amount}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                // Simulating payment processing
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("Booking Confirmed"),
                      content: Text("Your booking for ${widget.room['name']} on ${widget.date} at ${widget.timeSlot} has been confirmed."),
                      actions: [
                        TextButton(
                          onPressed: () {
                            // Navigate to the Order Summary Page after confirmation
                            Navigator.pushReplacementNamed(
                              context,
                              '/orderSummary',
                              arguments: {
                                'room': widget.room,
                                'date': widget.date,
                                'timeSlot': widget.timeSlot,
                                'amount': widget.amount,
                              }, // Pass the necessary data to the Order Summary
                            );
                          },
                          child: Text("OK"),
                        ),
                      ],
                    );
                  },
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
