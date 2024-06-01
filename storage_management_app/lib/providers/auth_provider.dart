// ignore_for_file: prefer_interpolation_to_compose_strings, avoid_print, use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:storage_management_app/models/login_model.dart';
import 'package:storage_management_app/utils/constant.dart';
import 'package:storage_management_app/utils/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  String? _token;
  DateTime? _tokenExpiry;
  LoginModel? _loginModel;

  LoginModel? get loginModel => _loginModel;
  String? get token => _token;

  AuthProvider() {
    _loadToken();
  }

  Future<void> _loadToken() async {
    final token = await SharedPreferencesUtil.getToken();
    final expiry = await SharedPreferencesUtil.getTokenExpiry();
    if (token != null && expiry != null) {
      if (DateTime.now().isAfter(expiry)) {
        await logout(null); // Ensure this is correct
      } else {
        _token = token;
        _tokenExpiry = expiry;
        // await _fetchUserProfile();
        _scheduleTokenExpiryCheck();
        notifyListeners();
      }
    }
  }

  Future<bool> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse(Constants.apiUrl + '/user/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username, 'password': password}),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        _token = responseData['token'];
        _tokenExpiry = JwtDecoder.getExpirationDate(_token!);

        // Print token to console
        // print('Token received: $_token');
        // print('Token expires at: $_tokenExpiry');

        await SharedPreferencesUtil.saveToken(_token!, _tokenExpiry!);
        // await _fetchUserProfile();
        _scheduleTokenExpiryCheck();
        notifyListeners();
        return true;
      } else {
        print('Login failed with status: ${response.statusCode}');
        print('Response body: ${response.body}');
        return false;
      }
    } catch (e) {
      print('An error occurred: $e');
      return false;
    }
  }

  Future<bool> register({
    required String username,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(Constants.apiUrl + '/user/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
      );

      if (response.statusCode == 201) {
        print('Registration successful');
        print('Response body: ${response.body}');
        return true;
      } else {
        print('Registration failed with status: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to register');
      }
    } catch (e) {
      print('An error occurred: $e');
      throw Exception('Failed to register');
    }
  }

  Future<bool> completeRegistration(String otp) async {
    try {
      final response = await http.post(
        Uri.parse(Constants.apiUrl + '/user/complete-register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'otp': otp}),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print(
            'Complete registration failed with status: ${response.statusCode}');
        print('Response body: ${response.body}');
        return false;
      }
    } catch (e) {
      print('An error occurred: $e');
      return false;
    }
  }

  // Future<void> _fetchUserProfile() async {
  //   if (_token == null) return;
  //   try {
  //     final response = await http.get(
  //       Uri.parse(Constants.apiUrl + '/user/profile'),
  //       headers: {'Authorization': 'Bearer $_token'},
  //     );

  //     if (response.statusCode == 200) {
  //       final responseData = jsonDecode(response.body);
  //       _user = UserModel.fromJson(responseData);
  //       notifyListeners();
  //     } else {
  //       print(
  //           'Failed to load user profile with status: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     print('An error occurred while fetching user profile: $e');
  //   }
  // }

  Future<void> logout(BuildContext? context) async {
    await SharedPreferencesUtil.removeToken();
    _token = null;
    _loginModel = null;
    _tokenExpiry = null;
    notifyListeners();
    if (context != null) {
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    }
  }

  bool isAuthenticated() {
    return _token != null &&
        _tokenExpiry != null &&
        DateTime.now().isBefore(_tokenExpiry!);
  }

  void _scheduleTokenExpiryCheck() {
    if (_tokenExpiry != null) {
      final timeToExpiry = _tokenExpiry!.difference(DateTime.now());
      Future.delayed(timeToExpiry, () {
        if (DateTime.now().isAfter(_tokenExpiry!)) {
          logout(null);
          notifyListeners();
        }
      });
    }
  }
}
