import 'dart:convert'; // For JSON decoding
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // Ensure you have this dependency in pubspec.yaml

class RoomDetailsPage extends StatefulWidget {
  @override
  _RoomDetailsPageState createState() => _RoomDetailsPageState();
}

class _RoomDetailsPageState extends State<RoomDetailsPage> {
  List<dynamic> rooms = [];
  bool isLoading = true;
  String errorMessage = '';
  int? selectedRoomIndex;

  @override
  void initState() {
    super.initState();
    fetchRooms(); // Call the function to fetch rooms when the widget is initialized
  }

  Future<void> fetchRooms() async {
    final String apiUrl = 'http://192.168.1.2:8000/api/rooms'; // Replace with your API URL
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        // Print the entire response to see its structure
        print('Response data: $responseData');

        // Check if rooms is a list
        if (responseData is List) {
          setState(() {
            rooms = responseData;
            isLoading = false; // Set loading to false once data is fetched
          });
        } else {
          setState(() {
            errorMessage = 'Invalid response structure: $responseData';
            isLoading = false;
          });
        }
      } else {
        setState(() {
          errorMessage = 'Failed to load rooms. Status code: ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (error) {
      setState(() {
        errorMessage = 'An error occurred: $error';
        isLoading = false;
      });
    }
  }

  double parsePrice(dynamic price) {
    // Try to parse the price as double
    if (price is String) {
      return double.tryParse(price) ?? 0.0; // Return 0.0 if parsing fails
    } else if (price is num) {
      return price.toDouble(); // Convert to double if it's a number
    }
    return 0.0; // Default case
  }

  Widget buildRoomDetails(int index) {
    final room = rooms[index];
    String roomName = room['name'] ?? 'No Name';
    int roomCapacity = room['capacity'] ?? 0;
    String imagePath = room['image_path'] ?? '';
    double pricePerHour = parsePrice(room['price_per_hour']);
    String imageUrl = 'http://192.168.1.2:8000/$imagePath';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            roomName,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.indigo),
          ),
        ),
        SizedBox(height: 8.0),
        Text('Capacity: $roomCapacity', style: TextStyle(color: Colors.indigo)),
        Text('Price per Hour: \$${pricePerHour.toStringAsFixed(2)}', style: TextStyle(color: Colors.indigo)),
        SizedBox(height: 8.0),
        imagePath.isNotEmpty
            ? Image.network(
          imageUrl,
          fit: BoxFit.cover,
          loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
                    : null,
              ),
            );
          },
          errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
            return Container(
              height: 100,
              color: Colors.grey[300],
              child: Icon(Icons.error, color: Colors.red),
            );
          },
        )
            : Container(
          height: 100,
          color: Colors.grey[300],
          child: Icon(Icons.error, color: Colors.red),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Room Details'),
        backgroundColor: Colors.indigo,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
          ? Center(child: Text(errorMessage))
          : CustomScrollView(
        slivers: [
          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedRoomIndex = selectedRoomIndex == index ? null : index; // Toggle room details
                    });
                  },
                  child: Card(
                    elevation: 4,
                    margin: EdgeInsets.all(8),
                    color: Colors.indigo[50],
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          ListTile(
                            title: Text(
                              rooms[index]['name'] ?? 'No Name',
                              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo),
                            ),
                            subtitle: Text('Click to see details', style: TextStyle(color: Colors.grey)),
                          ),
                          if (selectedRoomIndex == index) buildRoomDetails(index), // Show details if selected
                        ],
                      ),
                    ),
                  ),
                );
              },
              childCount: rooms.length, // Number of items in the list
            ),
          ),
        ],
      ),
    );
  }
}
