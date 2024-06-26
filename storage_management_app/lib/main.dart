// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:storage_management_app/providers/auth_provider.dart';
import 'package:storage_management_app/providers/category_provider.dart';
import 'package:storage_management_app/providers/product_provider.dart';
import 'package:storage_management_app/screens/form/add_category_form.dart';
import 'package:storage_management_app/screens/form/add_product_form.dart';
import 'package:storage_management_app/screens/login_screen.dart';
import 'package:storage_management_app/screens/home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return OverlaySupport.global(
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AuthProvider()),
          ChangeNotifierProvider(create: (_) => CategoryProvider()),
          ChangeNotifierProvider(create: (_) => ProductProvider()),
        ],
        child: Consumer<AuthProvider>(
          builder: (context, authProvider, _) {
            return MaterialApp(
              title: 'Storage Management App',
              initialRoute: authProvider.isAuthenticated() ? '/home' : '/login',
              routes: {
                '/login': (context) => LoginScreen(),
                '/home': (context) => HomeScreen(),
                '/addCategoryForm': (context) => AddCategoryForm(),
                '/add-product': (context) => AddProductScreen(),
              },
            );
          },
        ),
      ),
    );
  }
}
