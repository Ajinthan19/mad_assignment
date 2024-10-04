import 'package:flutter/material.dart';
import '../services/api_service.dart';

class AuthProvider with ChangeNotifier {
  ApiService _apiService = ApiService();
  String _token = '';
  bool _isAuthenticated = false;

  bool get isAuthenticated => _isAuthenticated;

  Future<void> registerCustomer(Map<String, String> data) async {
    try {
      final response = await _apiService.registerCustomer(data);
      if (response.containsKey('token')) {
        _token = response['token'];
        _isAuthenticated = true;
        notifyListeners();
      } else {
        throw Exception(response['message'] ?? 'Registration failed');
      }
    } catch (error) {
      throw error;
    }
  }

  Future<void> loginCustomer(Map<String, String> data) async {
    try {
      final response = await _apiService.loginCustomer(data);
      if (response.containsKey('token')) {
        _token = response['token'];
        _isAuthenticated = true;
        notifyListeners();
      } else {
        throw Exception(response['message'] ?? 'Login failed');
      }
    } catch (error) {
      throw error;
    }
  }
}
