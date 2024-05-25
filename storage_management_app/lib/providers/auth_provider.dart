// ignore_for_file: prefer_interpolation_to_compose_strings, avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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
      _loginModel = LoginModel(token: token);
      notifyListeners();
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

  bool isAuthenticated() {
    return _loginModel != null && _loginModel!.token != null;
  }
}
