// ignore_for_file: prefer_interpolation_to_compose_strings, avoid_print

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:storage_management_app/utils/constant.dart';
import 'package:storage_management_app/models/login_model.dart';
import 'package:storage_management_app/utils/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  LoginModel? _loginModel;

  LoginModel? get loginModel => _loginModel;

  AuthProvider() {
    _loadToken();
  }

  Future<void> _loadToken() async {
    final token = await SharedPreferencesUtil.getToken();
    if (token != null) {
      if (JwtDecoder.isExpired(token)) {
        await logout();
      } else {
        _loginModel = LoginModel(token: token);
        notifyListeners();
      }
    }
  }

  Future<void> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse(Constants.apiUrl + '/user/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username, 'password': password}),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final token = responseData['token'];
        if (JwtDecoder.isExpired(token)) {
          throw Exception('Token expired');
        }
        _loginModel = LoginModel(token: token);
        await SharedPreferencesUtil.saveToken(token);
        notifyListeners();
      } else {
        print('Login failed with status: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to login');
      }
    } catch (e) {
      print('An error occurred: $e');
      throw Exception('Failed to login');
    }
  }

  Future<void> logout() async {
    await SharedPreferencesUtil.removeToken();
    _loginModel = null;
    notifyListeners();
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

  bool isAuthenticated() {
    return _loginModel != null && _loginModel!.token != null;
  }
}
