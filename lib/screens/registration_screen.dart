import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'login_screen.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _fullNameController = TextEditingController();
  final _addressController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _occupationController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;

  // Function to handle registration
  Future<void> _register() async {
    String fullName = _fullNameController.text.trim();
    String address = _addressController.text.trim();
    String email = _emailController.text.trim();
    String phoneNumber = _phoneController.text.trim();
    String occupation = _occupationController.text.trim();
    String username = _usernameController.text.trim();
    String password = _passwordController.text.trim();
    String confirmPassword = _confirmPasswordController.text.trim();

    if (password.isEmpty || confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse('http://192.168.1.2:8000/api/customer/register'), // Backend URL
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          'full_name': fullName,
          'address': address,
          'email': email,
          'phone_number': phoneNumber,
          'occupation': occupation,
          'username': username,
          'password': password,
          'password_confirmation': confirmPassword,
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registration successful!')),
        );
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => LoginScreen()), // Navigates to the login page
        );
      } else {
        final errorResponse = json.decode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registration failed: ${errorResponse['message'] ?? 'Unknown error'}')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Registration failed: $error')));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.indigo, // AppBar color
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Card(
            elevation: 12.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Padding(
              padding: EdgeInsets.all(24.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Create Your Account',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo,
                      ),
                    ),
                    SizedBox(height: 30.0),
                    _buildTextField(_fullNameController, 'Full Name', Icons.person),
                    SizedBox(height: 16.0),
                    _buildTextField(_addressController, 'Address', Icons.home),
                    SizedBox(height: 16.0),
                    _buildTextField(_emailController, 'Email', Icons.email),
                    SizedBox(height: 16.0),
                    _buildTextField(_phoneController, 'Phone Number', Icons.phone),
                    SizedBox(height: 16.0),
                    _buildTextField(_occupationController, 'Occupation', Icons.work),
                    SizedBox(height: 16.0),
                    _buildTextField(_usernameController, 'Username', Icons.account_circle),
                    SizedBox(height: 16.0),
                    _buildPasswordField(_passwordController, 'Password'),
                    SizedBox(height: 16.0),
                    _buildPasswordField(_confirmPasswordController, 'Confirm Password'),
                    SizedBox(height: 30.0),
                    _isLoading
                        ? CircularProgressIndicator()
                        : ElevatedButton(
                      onPressed: _register,
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 80.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        backgroundColor: Colors.indigo[100], // Button background color
                      ),
                      child: Text(
                        'Register',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Helper widget for text fields
  Widget _buildTextField(TextEditingController controller, String labelText, IconData icon) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
    );
  }

  // Helper widget for password fields
  Widget _buildPasswordField(TextEditingController controller, String labelText) {
    return TextField(
      controller: controller,
      obscureText: true,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(Icons.lock),
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
    );
  }
}
