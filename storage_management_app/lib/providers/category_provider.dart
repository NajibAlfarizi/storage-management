// ignore_for_file: avoid_print, prefer_interpolation_to_compose_strings

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:storage_management_app/models/category_model.dart';
import 'package:storage_management_app/models/product_model.dart';
import 'package:storage_management_app/utils/constant.dart';
import 'package:storage_management_app/utils/shared_preferences.dart';

class CategoryProvider with ChangeNotifier {
  List<Category> _categories = [];
  List<Product> _productsByCategoryId = [];

  List<Category> get categories => _categories;
  List<Product> getProductsByCategoryId(String categoryId) {
    return _productsByCategoryId;
  }

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

  Future<void> fetchCategoryById(int categoryId) async {
    final token = await SharedPreferencesUtil.getToken();
    if (token == null) return;

    try {
      final response = await http.get(
        Uri.parse(Constants.apiUrl + '/category/$categoryId'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        _productsByCategoryId = (responseData['products'] as List<dynamic>)
            .map((json) => Product.fromJson(json))
            .toList();
        notifyListeners(); // Wrap in a list
      } else {
        print('Failed to fetch category with ID $categoryId');
      }
    } catch (e) {
      print('An error occurred while fetching category: $e');
    }
  }

  Future<void> addCategory(String categoryName) async {
    final token = await SharedPreferencesUtil.getToken();
    if (token == null) return;

    try {
      final response = await http.post(
        Uri.parse(Constants.apiUrl + '/category'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json'
        },
        body: jsonEncode({'name': categoryName}),
      );

      if (response.statusCode == 201) {
        final Category newCategory =
            Category.fromJson(jsonDecode(response.body));
        _categories.add(newCategory);
        notifyListeners();
      } else {
        print('Failed to add category: ${response.statusCode}');
      }
    } catch (e) {
      print('An error occurred while adding category: $e');
    }
  }

  Future<void> updateCategory(int categoryId, String categoryName) async {
    final token = await SharedPreferencesUtil.getToken();
    if (token == null) return;

    try {
      final response = await http.put(
        Uri.parse(Constants.apiUrl + '/category/$categoryId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json'
        },
        body: jsonEncode({'name': categoryName}),
      );

      if (response.statusCode == 200) {
        final Category updatedCategory =
            Category.fromJson(jsonDecode(response.body));
        int index =
            _categories.indexWhere((category) => category.id == categoryId);
        if (index != -1) {
          _categories[index] = updatedCategory;
          notifyListeners();
        }
      } else {
        print('Failed to update category: ${response.statusCode}');
      }
    } catch (e) {
      print('An error occurred while updating category: $e');
    }
  }

  Future<void> deleteCategory(int categoryId) async {
    final token = await SharedPreferencesUtil.getToken();
    if (token == null) return;

    try {
      final response = await http.delete(
        Uri.parse(Constants.apiUrl + '/category/$categoryId'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        _categories.removeWhere((category) => category.id == categoryId);
        notifyListeners();
      } else {
        print('Failed to delete category: ${response.statusCode}');
      }
    } catch (e) {
      print('An error occurred while deleting category: $e');
    }
  }
}
