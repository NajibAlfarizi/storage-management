// ignore_for_file: avoid_print, prefer_interpolation_to_compose_strings

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:storage_management_app/models/product_model.dart';
import 'package:storage_management_app/utils/constant.dart';
import 'package:storage_management_app/utils/shared_preferences.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _products = [];
  List<Product> get products => _products;

  Future<void> fetchProducts() async {
    final token = await SharedPreferencesUtil.getToken();
    if (token == null) return;

    try {
      final response = await http.get(
        Uri.parse(Constants.apiUrl + '/product'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200) {
        final List<dynamic> responseData = jsonDecode(response.body);
        _products = responseData.map((json) => Product.fromJson(json)).toList();
        notifyListeners();
      } else {
        print('Failed to fetch products. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('An error occurred: $e');
    }
  }
}
