import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:storage_management_app/providers/auth_provider.dart';
import 'package:storage_management_app/providers/category_provider.dart';
import 'package:storage_management_app/providers/product_provider.dart';
import 'package:storage_management_app/screens/login_screen.dart';
import 'package:storage_management_app/screens/home_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => AuthProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return OverlaySupport(
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => CategoryProvider()),
          ChangeNotifierProvider(create: (_) => ProductProvider()),
        ],
        child: MaterialApp(
          title: 'Storage Management App',
          initialRoute: '/',
          routes: {
            '/': (context) {
              final authProvider =
                  Provider.of<AuthProvider>(context, listen: false);
              return authProvider.isAuthenticated()
                  ? HomeScreen()
                  : LoginScreen();
            },
            '/login': (context) => LoginScreen(),
            '/home': (context) => HomeScreen(),
          },
        ),
      ),
    );
  }
}
