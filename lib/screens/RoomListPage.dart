import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'RoomBookingCalendarPage.dart';

class AvailableRooms extends StatelessWidget {
  // Dummy data for rooms
  final List<Map<String, dynamic>> rooms = [
    {
      'id': 1,
      'name': 'Master Discussion Room',
      'capacity': 25,
      'pricePerHour': 5000,
    },
    {
      'id': 2,
      'name': 'Personal Meetings',
      'capacity': 5,
      'pricePerHour': 4000,
    },
    {
      'id': 3,
      'name': 'friends Discussion',
      'capacity': 10,
      'pricePerHour': 2000,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Available Rooms'),
        backgroundColor: Colors.indigo,
      ),
      body: ListView.builder(
        itemCount: rooms.length,
        itemBuilder: (context, index) {
          final room = rooms[index];
          return Card(
            color: Colors.indigo[100],
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListTile(
              title: Text(
                room['name'],
                style: TextStyle(fontSize: 18, color: Colors.indigo[900]),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Capacity: ${room['capacity']}'),
                  Text('Price per hour: \$${room['pricePerHour']}'),
                ],
              ),
              trailing: Icon(Icons.arrow_forward_ios, color: Colors.indigo),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RoomBookingCalendarPage(room: room, userName: '',),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
