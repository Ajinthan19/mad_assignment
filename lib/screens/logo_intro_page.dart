import 'package:flutter/material.dart';
import 'login_screen.dart';

class IntroPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()), // Navigate to LoginScreen
      );
    });

    return Scaffold(
      backgroundColor: Colors.indigo[100], // Indigo background color
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo-no-background.png', // Ensure the logo path is correct
              height: 150, // Adjust logo size as needed
            ),
            SizedBox(height: 20),
            Text(
              'Welcome to Colombo City Space', // Customize the welcome text
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Loading, please wait...',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
