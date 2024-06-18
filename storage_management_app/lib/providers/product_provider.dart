// ignore_for_file: avoid_print, prefer_interpolation_to_compose_strings

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:storage_management_app/models/category_model.dart';
import 'package:storage_management_app/models/product_model.dart';
import 'package:storage_management_app/utils/constant.dart';
import 'package:storage_management_app/utils/shared_preferences.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _products = [];
  List<Product> get products => _products;
  final List<Category> _categories = [];
  List<Category> get categories => _categories;
  int? _categoryId;
  int? get categoryId => _categoryId;

  void setCategoryId(int categoryId) {
    _categoryId = categoryId;
    notifyListeners();
  }

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

  Future<Product?> fetchProductById(int productId) async {
    final token = await SharedPreferencesUtil.getToken();
    if (token == null) return null;

    try {
      final response = await http.get(
        Uri.parse(Constants.apiUrl + '/product/$productId'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return Product.fromJson(json);
      } else {
        print('Failed to fetch product by id: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('An error occurred while fetching product by id: $e');
      return null;
    }
  }

  Future<void> addProduct(BuildContext context, String productName, int qty,
      String? productImage, int categoryId) async {
    final token = await SharedPreferencesUtil.getToken();
    if (token == null) return;

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('${Constants.apiUrl}/product'),
      );
      request.headers['Authorization'] = 'Bearer $token';
      request.fields['name'] = productName;
      request.fields['qty'] = qty.toString();
      request.fields['categoryId'] = categoryId.toString();

      if (productImage != null && productImage.isNotEmpty) {
        request.files
            .add(await http.MultipartFile.fromPath('url', productImage));
      }

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 201) {
        final newProduct = Product.fromJson(jsonDecode(responseBody));
        _products.add(newProduct);
        notifyListeners();
      } else {
        print('Failed to add product: ${response.statusCode}');
        print('Response body: $responseBody');
      }
    } catch (e) {
      print('An error occurred while adding product: $e');
    }
  }

  Future<void> updateProduct(int productId, String productName, int productQty,
      String? productImage, int categoryId) async {
    final token = await SharedPreferencesUtil.getToken();
    if (token == null) return;

    try {
      var request = http.MultipartRequest(
        'PUT',
        Uri.parse('${Constants.apiUrl}/product/$productId'),
      );
      request.headers['Authorization'] = 'Bearer $token';
      request.fields['name'] = productName;
      request.fields['qty'] = productQty.toString();
      request.fields['categoryId'] = categoryId.toString();

      if (productImage != null && productImage.isNotEmpty) {
        request.files
            .add(await http.MultipartFile.fromPath('url', productImage));
      }

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final updatedProduct = Product.fromJson(jsonDecode(responseBody));
        int index = _products.indexWhere((product) => product.id == productId);
        if (index != -1) {
          _products[index] = updatedProduct;
          notifyListeners();
        }
      } else {
        print('Failed to update product: ${response.statusCode}');
        print('Response body: $responseBody');
      }
    } catch (e) {
      print('An error occurred while updating product: $e');
    }
  }

  Future<void> deleteProduct(int productId) async {
    final token = await SharedPreferencesUtil.getToken();
    if (token == null) return;

    try {
      final response = await http.delete(
        Uri.parse(Constants.apiUrl + '/product/$productId'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        _products.removeWhere((product) => product.id == productId);
        notifyListeners();
      } else {
        print('Failed to delete product: ${response.statusCode}');
      }
    } catch (e) {
      print('An error occurred while deleting product: $e');
    }
  }
}
