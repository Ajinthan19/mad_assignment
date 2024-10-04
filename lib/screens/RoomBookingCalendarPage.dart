import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'payment_page.dart';

class RoomBookingCalendarPage extends StatefulWidget {
  final Map<String, dynamic> room;
  final String userName; // Add userName to the widget

  RoomBookingCalendarPage({required this.room, required this.userName}); // Accept userName in the constructor

  @override
  _RoomBookingCalendarPageState createState() => _RoomBookingCalendarPageState();
}

class _RoomBookingCalendarPageState extends State<RoomBookingCalendarPage> {
  DateTime? selectedDate;
  String? selectedTimeSlot;

  // Dummy data for available time slots
  final Map<String, List<String>> availableTimeSlots = {
    '2024-10-10': ['9:00 AM - 11:00 AM', '1:00 PM - 3:00 PM'],
    '2024-10-11': ['10:00 AM - 12:00 PM', '2:00 PM - 4:00 PM'],
    '2024-10-12': ['8:00 AM - 10:00 AM', '12:00 PM - 2:00 PM'],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.room['name']} Booking'),
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
            Text('Capacity: ${widget.room['capacity']}'),
            Text('Price per hour: \$${widget.room['pricePerHour']}'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2100),
                );
                if (pickedDate != null) {
                  setState(() {
                    selectedDate = pickedDate;
                    selectedTimeSlot = null; // Reset timeslot when date changes
                  });
                }
              },
              child: Text('Select Date'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo, // Background color
              ),
            ),
            SizedBox(height: 10),
            // Display selected date
            Text(
              selectedDate != null
                  ? 'Selected Date: ${DateFormat('yyyy-MM-dd').format(selectedDate!)}'
                  : 'No Date Chosen',
              style: TextStyle(fontSize: 16, color: Colors.indigo[700]),
            ),
            SizedBox(height: 20),
            // Show available time slots for the selected date
            if (selectedDate != null)
              Expanded(
                child: ListView.builder(
                  itemCount: (availableTimeSlots[DateFormat('yyyy-MM-dd').format(selectedDate!)] ?? []).length,
                  itemBuilder: (context, index) {
                    List<String> slots = availableTimeSlots[DateFormat('yyyy-MM-dd').format(selectedDate!)] ?? [];
                    if (slots.isEmpty) {
                      return Center(child: Text('No slots available.'));
                    }
                    return ListTile(
                      title: Text(slots[index]),
                      leading: Radio<String>(
                        value: slots[index],
                        groupValue: selectedTimeSlot,
                        onChanged: (value) {
                          setState(() {
                            selectedTimeSlot = value;
                          });
                        },
                      ),
                    );
                  },
                ),
              ),
            SizedBox(height: 20),
            // Confirm booking button
            if (selectedTimeSlot != null)
              Center(
                child: ElevatedButton(
                  onPressed: _confirmBooking,
                  child: Text('Confirm Booking'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _confirmBooking() {
    final String date = DateFormat('yyyy-MM-dd').format(selectedDate!);
    final String timeSlot = selectedTimeSlot!; // Use the correct variable name

    // Navigate to the Payment Page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentPage(
          room: widget.room, // Pass room details
          date: date, // Pass selected date
          timeSlot: timeSlot, // Pass selected time slot
          userName: widget.userName, // Pass the userName
        ),
      ),
    );
  }
}
