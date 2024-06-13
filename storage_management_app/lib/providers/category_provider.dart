import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:storage_management_app/models/category_model.dart';
import 'package:storage_management_app/utils/constant.dart';
import 'package:storage_management_app/utils/shared_preferences.dart';

class CategoryProvider with ChangeNotifier {
  List<Category> _categories = [];

  List<Category> get categories => _categories;

  Future<void> fetchCategories() async {
    final token = await SharedPreferencesUtil.getToken();
    if (token == null) return;

    try {
      final response = await http.get(
        Uri.parse(Constants.apiUrl + '/category'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> responseData = jsonDecode(response.body);
        _categories =
            responseData.map((json) => Category.fromJson(json)).toList();
        notifyListeners();
      } else {
        print('Failed to load categories with status: ${response.statusCode}');
      }
    } catch (e) {
      print('An error occurred while fetching categories: $e');
    }
  }
}
