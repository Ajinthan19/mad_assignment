import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bookmyspace/providers/theme_provider.dart'; // Ensure this is the correct path

class UserHomePage extends StatelessWidget {
  final String userName;

  UserHomePage({required this.userName});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        backgroundColor: themeProvider.themeMode == ThemeMode.dark ? Colors.black : Colors.indigo, // AppBar color based on theme
        actions: [
          // Add a switch to toggle the theme
          Switch(
            value: themeProvider.themeMode == ThemeMode.dark,
            onChanged: (value) {
              // Toggle the theme
              themeProvider.toggleTheme();
            },
            activeColor: Colors.yellow, // Switch color when active
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Text(
              'Hello $userName!',
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width > 600 ? 30 : 24,
                fontWeight: FontWeight.bold,
                color: themeProvider.themeMode == ThemeMode.dark ? Colors.white : Colors.black, // Text color based on theme
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: MediaQuery.of(context).orientation == Orientation.portrait ? 2 : 4,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                children: [
                  _buildGridItem(context, 'assets/images/rooms.png', 'Check Rooms', '/room-details'),
                  _buildGridItem(context, 'assets/images/booking.png', 'Book Rooms', '/available-rooms'),
                  _buildGridItem(context, 'assets/images/dashboard.png', 'Dashboard', '/dashboard'),
                  _buildGridItem(context, 'assets/images/review.png', 'Rate & Review', '/rateReview'),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Order Summary'),
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        currentIndex: 0,
        selectedItemColor: Colors.yellow, // Color for selected item
        unselectedItemColor: themeProvider.themeMode == ThemeMode.dark ? Colors.white70 : Colors.black54, // Unselected color based on theme
        backgroundColor: themeProvider.themeMode == ThemeMode.dark ? Colors.black : Colors.indigo, // Background color based on theme
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          switch (index) {
            case 0:
              break;
            case 1:
              Navigator.pushNamed(context, '/orderSummary', arguments: userName);
              break;
            case 2:
              Navigator.pushNamed(context, '/dashboard', arguments: userName);
              break;
            case 3:
              Navigator.pushNamed(context, '/profile', arguments: userName);
              break;
          }
        },
      ),
    );
  }

  Widget _buildGridItem(BuildContext context, String imagePath, String title, String route) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, route, arguments: userName);
      },
      child: Card(
        elevation: 5,
        color: themeProvider.themeMode == ThemeMode.dark ? Colors.grey[850] : Colors.white, // Card color based on theme
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(imagePath, height: 100),
            SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: themeProvider.themeMode == ThemeMode.dark ? Colors.white : Colors.black, // Text color based on theme
              ),
            ),
          ],
        ),
      ),
    );
  }
}
