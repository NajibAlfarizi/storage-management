// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, use_key_in_widget_constructors, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storage_management_app/providers/category_provider.dart';
import 'package:storage_management_app/providers/product_provider.dart';
import 'package:storage_management_app/screens/form/add_product_form.dart';
import 'package:storage_management_app/screens/tab_screens/product_detail.dart';

class CatalogTab extends StatefulWidget {
  @override
  _CatalogTabState createState() => _CatalogTabState();
}

class _CatalogTabState extends State<CatalogTab> {
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final categoryProvider =
        Provider.of<CategoryProvider>(context, listen: false);
    final productProvider =
        Provider.of<ProductProvider>(context, listen: false);
    await categoryProvider.fetchCategories();
    await productProvider.fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer2<CategoryProvider, ProductProvider>(
        builder: (context, categoryProvider, productProvider, child) {
          final categories = categoryProvider.categories;
          final products = productProvider.products;

          if (categories.isEmpty || products.isEmpty) {
            return Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    'Categories',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  height: 50,
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length +
                        1, // tambahkan 1 untuk item tambahan
                    itemBuilder: (context, index) {
                      if (index < categories.length) {
                        // kode sebelumnya untuk menampilkan category
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () async {
                              setState(() {
                                _selectedCategory = categories[index].name;
                              });
                              if (categories[index].id != null) {
                                await categoryProvider
                                    .fetchCategoryById(categories[index].id!);
                              }
                            },
                            child: Chip(
                              label: Text(categories[index].name ??
                                  'product name undefined'),
                              backgroundColor:
                                  _selectedCategory == categories[index].name
                                      ? const Color.fromARGB(255, 1, 28, 74)
                                      : Colors.white,
                              labelStyle: TextStyle(
                                color:
                                    _selectedCategory == categories[index].name
                                        ? Colors.white
                                        : Colors.black,
                              ),
                            ),
                          ),
                        );
                      } else {
                        // item tambahan untuk menampilkan icon +
                        return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  '/addCategoryForm',
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border:
                                      Border.all(width: 2, color: Colors.blue),
                                ),
                                child: Icon(Icons.add,
                                    size: 24, color: Colors.blue),
                              ),
                            ));
                      }
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Hi, there! Here is your product catalog',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w700),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.add_circle_outline_rounded,
                          color: Colors.blue,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddProductScreen()),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 550, // adjust the height to your needs
                  child: ListView.builder(
                    padding: EdgeInsets.all(8.0),
                    itemCount: _selectedCategory != null
                        ? categoryProvider
                            .getProductsByCategoryId(_selectedCategory!)
                            .length
                        : products.length,
                    itemBuilder: (context, index) {
                      final product = _selectedCategory != null
                          ? categoryProvider.getProductsByCategoryId(
                              _selectedCategory!)[index]
                          : products[index];
                      return Card(
                        elevation: 6,
                        margin: EdgeInsets.all(6.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32.0),
                        ),
                        child: ListTile(
                          contentPadding: EdgeInsets.all(4.0),
                          leading: Container(
                            width: 100,
                            padding: EdgeInsets.all(2.0),
                            child: ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(12.0), // add this line
                              child: Image.network(
                                product.url ?? '',
                                fit: BoxFit.cover,
                                width: double.infinity,
                                errorBuilder: (context, error, stackTrace) {
                                  return Icon(Icons.image, size: 50);
                                },
                              ),
                            ),
                          ),
                          title: Text(
                            product.name ?? '',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [Text('Quantity: ${product.qty}')],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit),
                                color: Colors.blue,
                                onPressed: () {
                                  // navigate to edit product screen
                                  // Navigator.pushNamed(context, '/edit-product',
                                  //     arguments: product);
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                color: Colors.red,
                                onPressed: () async {
                                  // Show a confirmation dialog before deleting the product
                                  bool confirmDelete = await showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Text('Delete Product'),
                                      content: Text(
                                          'Are you sure you want to delete this product?'),
                                      actions: [
                                        TextButton(
                                          child: Text('Cancel'),
                                          onPressed: () =>
                                              Navigator.of(context).pop(false),
                                        ),
                                        TextButton(
                                          child: Text('Delete'),
                                          onPressed: () =>
                                              Navigator.of(context).pop(true),
                                        ),
                                      ],
                                    ),
                                  );

                                  if (confirmDelete) {
                                    // Delete the product
                                    try {
                                      await productProvider
                                          .deleteProduct(product.id!);
                                      // Show a snackbar to confirm the deletion
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                              'Product deleted successfully'),
                                        ),
                                      );
                                    } catch (e) {
                                      // Show an error message if the deletion fails
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                              'Error deleting product: $e'),
                                        ),
                                      );
                                    }
                                  }
                                },
                              )
                            ],
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ProductDetailsScreen(product: product),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
