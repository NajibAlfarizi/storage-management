// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:storage_management_app/providers/auth_provider.dart';
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
        child: MaterialApp(
      title: 'Storage Management App',
      initialRoute: '/',
      routes: {
        '/': (context) {
          final authProvider =
              Provider.of<AuthProvider>(context, listen: false);
          return authProvider.isAuthenticated() ? HomeScreen() : LoginScreen();
        },
        '/login': (context) => LoginScreen(),
        '/home': (context) => HomeScreen(),
      },
    ));
    // return MaterialApp(
    //   title: 'Storage Management App',
    //   initialRoute: '/',
    //   routes: {
    //     '/': (context) {
    //       final authProvider =
    //           Provider.of<AuthProvider>(context, listen: false);
    //       return authProvider.isAuthenticated() ? HomeScreen() : LoginScreen();
    //     },
    //     '/login': (context) => LoginScreen(),
    //     '/home': (context) => HomeScreen(),
    //   },
    // );
  }
}
