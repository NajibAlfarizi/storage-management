// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storage_management_app/providers/category_provider.dart';
import 'package:storage_management_app/providers/product_provider.dart';

class HomeTab extends StatefulWidget {
  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
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
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
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
                              color: _selectedCategory == categories[index].name
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    'Products',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                GridView.builder(
                  padding: EdgeInsets.all(12.0),
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: _selectedCategory != null
                      ? categoryProvider
                          .getProductsByCategoryId(_selectedCategory!)
                          .length
                      : products.length,
                  itemBuilder: (context, index) {
                    final product = _selectedCategory != null
                        ? categoryProvider
                            .getProductsByCategoryId(_selectedCategory!)[index]
                        : products[index];

                    return Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Image.network(
                              product.url ?? '',
                              fit: BoxFit.cover,
                              width: double.infinity,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(Icons.image, size: 50);
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(product.name ?? ''),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Qty: ${product.qty}'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
