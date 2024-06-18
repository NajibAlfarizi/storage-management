// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:storage_management_app/models/product_model.dart';
import 'package:storage_management_app/providers/category_provider.dart';
import 'package:storage_management_app/providers/product_provider.dart';
import 'package:storage_management_app/screens/home_screen.dart';

class ProductDetailsScreen extends StatelessWidget {
  final Product product;

  ProductDetailsScreen({required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.name ?? ''),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              child: Image.network(
                product.url ?? '',
                fit: BoxFit.cover,
                height: 200,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Name:',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                Text(
                  product.name ?? '',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Quantity:',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                Text(
                  '${product.qty ?? 0}',
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Created By:',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                Text(
                  product.createdBy ?? '',
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Updated By:',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                Text(
                  product.updatedBy ?? '',
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _showUpdateProductOverlay(context, product);
              },
              child: Text('Update Product'),
            ),
          ],
        ),
      ),
    );
  }

  void _showUpdateProductOverlay(BuildContext context, Product product) {
    showDialog(
      context: context,
      builder: (context) {
        return UpdateProductOverlay(product: product);
      },
    );
  }
}

class UpdateProductOverlay extends StatefulWidget {
  final Product product;

  UpdateProductOverlay({required this.product});

  @override
  _UpdateProductOverlayState createState() => _UpdateProductOverlayState();
}

class _UpdateProductOverlayState extends State<UpdateProductOverlay> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _qtyController = TextEditingController();
  PickedFile? _image;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.product.name ?? '';
    _qtyController.text = widget.product.qty?.toString() ?? '';
  }

  int? _selectedCategoryId;

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final categories = Provider.of<CategoryProvider>(context).categories;
    return AlertDialog(
      title: Text('Update Product'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
            DropdownButtonFormField<int>(
              decoration: InputDecoration(labelText: 'Category'),
              items: categories.map((category) {
                return DropdownMenuItem<int>(
                  value: category.id,
                  child: Text(category.name ?? 'No Category'),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCategoryId = value;
                });
              },
              value: _selectedCategoryId,
              validator: (value) {
                if (value == null) {
                  return 'Please select a category';
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final pickedFile =
                    await ImagePicker().pickImage(source: ImageSource.gallery);
                setState(() {
                  _image =
                      pickedFile != null ? PickedFile(pickedFile.path) : null;
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
                  final productImage = _image?.path ?? '';

                  await productProvider.updateProduct(
                    widget.product.id!,
                    productName,
                    productQty,
                    productImage,
                    _selectedCategoryId!,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Product successfully updated'),
                    ),
                  );

                  // Tutup dialog dan kembali ke layar sebelumnya
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                    (Route<dynamic> route) => false,
                  );
                }
              },
              child: Text('Update Product'),
            ),
          ],
        ),
      ),
    );
  }
}
