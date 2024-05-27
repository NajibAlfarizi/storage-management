// otp_screen.dart
// ignore_for_file: prefer_const_constructors, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storage_management_app/providers/auth_provider.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:storage_management_app/screens/login_screen.dart';

class OtpScreen extends StatefulWidget {
  final String username;

  OtpScreen({required this.username});

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  String? _otp;
  final _formKey = GlobalKey<FormState>();

  Future<void> _completeRegistration() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    if (_formKey.currentState?.validate() ?? false) {
      bool isCompleted = await authProvider.completeRegistration(_otp!);

      if (isCompleted) {
        showSimpleNotification(
          Text("Registration Successful"),
          background: Colors.green,
        );

        Future.delayed(Duration(seconds: 2), () {
          Navigator.pop(context); // Tutup halaman OTP
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen()),
          );
        });
      } else {
        showSimpleNotification(
          Text("Invalid OTP"),
          background: Colors.red,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Enter OTP'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                TextFormField(
                  onChanged: (value) => _otp = value,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.security),
                    hintText: 'Enter OTP...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the OTP';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _completeRegistration,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Color.fromARGB(255, 0, 38, 68),
                  ),
                  child: Text(
                    'VERIFY OTP',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
