// ignore_for_file: unnecessary_null_comparison, use_key_in_widget_constructors, library_private_types_in_public_api, prefer_const_constructors, use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:storage_management_app/providers/category_provider.dart';
import 'package:storage_management_app/providers/product_provider.dart';
import 'package:storage_management_app/screens/home_screen.dart';

class AddProductScreen extends StatefulWidget {
  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _qtyController = TextEditingController();
  XFile? _image;

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final categories = Provider.of<CategoryProvider>(context).categories;

    return Scaffold(
      appBar: AppBar(
        title: Text('Add Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _qtyController,
                decoration: InputDecoration(labelText: 'Quantity'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a quantity';
                  }
                  return null;
                },
              ),
              categories != null
                  ? DropdownButtonFormField<int>(
                      decoration: InputDecoration(labelText: 'Category'),
                      items: categories.map((category) {
                        return DropdownMenuItem<int>(
                          value: category.id,
                          child: Text(category.name ?? 'No Category'),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            productProvider.setCategoryId(value);
                          });
                        }
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Please select a category';
                        }
                        return null;
                      },
                    )
                  : CircularProgressIndicator(),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  final pickedFile = await ImagePicker()
                      .pickImage(source: ImageSource.gallery);
                  setState(() {
                    _image = pickedFile;
                  });
                },
                child: Text('Select Image'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final productName = _nameController.text;
                    final productQty = int.parse(_qtyController.text);
                    final productImage =
                        _image != null ? File(_image!.path) : null;
                    final categoryId = productProvider.categoryId ?? 0;

                    await productProvider.addProduct(
                      context,
                      productName,
                      productQty,
                      productImage?.path,
                      categoryId,
                    );

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Product successfully added'),
                      ),
                    );

                    // Tutup dialog dan kembali ke layar sebelumnya
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => HomeScreen()),
                      (Route<dynamic> route) => false,
                    );
                  }
                },
                child: Text('Add Product'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
