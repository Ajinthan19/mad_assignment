import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    // Get screen size and orientation
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final orientation = MediaQuery.of(context).orientation;

    return Scaffold(
      backgroundColor: Colors.indigo[100],
      appBar: AppBar(
        title: Text('Login'),
        backgroundColor: Colors.indigo,
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: orientation == Orientation.portrait ? screenHeight * 0.1 : screenHeight * 0.05),

              // Logo with size based on screen height
              Image.asset(
                'assets/images/logo-no-background.png',
                height: orientation == Orientation.portrait ? screenHeight * 0.2 : screenHeight * 0.1,
              ),
              SizedBox(height: screenHeight * 0.05),

              // Welcome Text with adaptable font size
              Text(
                'Welcome Back!',
                style: TextStyle(
                  fontSize: orientation == Orientation.portrait ? screenHeight * 0.03 : screenHeight * 0.04,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: screenHeight * 0.02),

              // Username TextField
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              SizedBox(height: screenHeight * 0.02),

              // Password TextField
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
                obscureText: true,
              ),
              SizedBox(height: screenHeight * 0.03),

              // Login Button
              ElevatedButton(
                onPressed: _isLoading ? null : _login,
                child: _isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text('Login'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo[400],
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.2,
                    vertical: screenHeight * 0.02,
                  ),
                  textStyle: TextStyle(fontSize: screenHeight * 0.02),
                ),
              ),
              SizedBox(height: screenHeight * 0.03),

              // Register Link
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/register');
                },
                child: Text(
                  "Don't have an account? Register here",
                  style: TextStyle(
                    color: Colors.indigo,
                    fontSize: screenHeight * 0.018,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Login method
  Future<void> _login() async {
    String username = _usernameController.text;
    String password = _passwordController.text;

    if (username.isNotEmpty && password.isNotEmpty) {
      setState(() {
        _isLoading = true;
      });

      // Backend API URL
      Uri apiUrl = Uri.parse('http://192.168.1.2:8000/api/customer/login');

      // Create request body
      Map<String, dynamic> body = {
        'username': username,
        'password': password,
      };

      try {
        // Make the POST request
        final response = await http.post(
          apiUrl,
          headers: {'Content-Type': 'application/json'},
          body: json.encode(body),
        );

        // Check the response status
        if (response.statusCode == 200) {
          // Parse the response body
          final responseData = json.decode(response.body);

          // Assuming the backend sends a token in the response
          String token = responseData['token'];

          // Save the token to SharedPreferences
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', token);
          await prefs.setString('userName', username); // Optionally save the username

          // Navigate to home page and pass username
          Navigator.of(context).pushReplacementNamed('/home', arguments: username);
        } else {
          // Handle error response
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Invalid credentials or server error')),
          );
        }
      } catch (e) {
        // Handle network error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An error occurred: $e')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in both fields')),
      );
    }
  }
}
