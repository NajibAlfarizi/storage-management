// screens/register_screen.dart
// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, library_private_types_in_public_api, avoid_print

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:storage_management_app/providers/auth_provider.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:storage_management_app/screens/otp_screen.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String username = '';
  String password = '';
  File? _imageFile;
  final _formKey = GlobalKey<FormState>();

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> _register() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    if (_formKey.currentState?.validate() ?? false) {
      bool isRegistered = await authProvider.register(
        username: username,
        password: password,
        image: _imageFile,
      );

      if (isRegistered) {
        showSimpleNotification(
          Text("OTP sent to your email"),
          background: Colors.green,
        );

        Future.delayed(Duration(seconds: 2), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => OtpScreen(username: username)),
          );
        });
      } else {
        showSimpleNotification(
          Text("Registration failed"),
          background: Colors.red,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
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
                  onChanged: (value) => username = value,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.person),
                    hintText: 'Username...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your username';
                    } else if (!value.contains('@gmail.com')) {
                      return 'Username must include @gmail.com';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  onChanged: (value) => password = value,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock),
                    hintText: 'Password...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                if (_imageFile != null)
                  Image.file(
                    _imageFile!,
                    height: 100,
                  ),
                SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () => _pickImage(ImageSource.gallery),
                  child: Text('Choose Image'),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _register,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Color.fromARGB(255, 0, 38, 68),
                  ),
                  child: Text(
                    'REGISTER',
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
