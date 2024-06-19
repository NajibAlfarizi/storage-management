// ignore_for_file: unnecessary_string_interpolations, prefer_const_constructors, use_key_in_widget_constructors, library_private_types_in_public_api, sort_child_properties_last

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:storage_management_app/models/user_model.dart';
import 'package:storage_management_app/providers/auth_provider.dart';
import 'package:storage_management_app/screens/login_screen.dart';

class ProfileTab extends StatefulWidget {
  @override
  _ProfileTabState createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  bool _loading = true;
  UserModel? _user;
  XFile? _image;
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  Future<void> _fetchUserProfile() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.fetchUserProfile().then((_) {
      setState(() {
        _loading = false;
        _user = authProvider.user;
      });
    });
  }

  Future<void> _updateProfile() async {
    setState(() {
      _loading = true;
    });
    await AuthProvider().updateProfile(
      password: _passwordController.text,
      image: _image?.path,
    );
    setState(() {
      _loading = false;
    });
  }

  void _showUpdateProfileDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Update Profile'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _image != null
                  ? CircleAvatar(
                      radius: 50,
                      backgroundImage: Image.file(_image! as File).image,
                    )
                  : CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(_user!.image),
                    ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  _image = await ImagePicker()
                      .pickImage(source: ImageSource.gallery);
                },
                child: Text('Change Profile Picture'),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'New Password',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                _updateProfile();
                Navigator.of(context).pop();
              },
              child: Text('Update Profile'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    return Scaffold(
      body: Center(
        child: _loading
            ? CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 100,
                    backgroundImage: NetworkImage(_user!.image),
                  ),
                  SizedBox(height: 40),
                  Text(
                    '${_user!.username}',
                    style: TextStyle(fontSize: 22),
                  ),
                  TextButton(
                    onPressed: _showUpdateProfileDialog,
                    child: Text('Update Profile',
                        style: TextStyle(color: Colors.white)),
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.blue),
                    ),
                  ),
                  SizedBox(height: 30),
                  TextButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('Confirm Logout'),
                            content: Text('Are you sure you want to logout?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context); // close the dialog
                                },
                                child: Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  authProvider.logout(context);
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LoginScreen()),
                                    (Route<dynamic> route) => false,
                                  );
                                },
                                child: Text('Logout'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Text(
                      'Logout',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.red),
                    ),
                  )
                ],
              ),
      ),
    );
  }
}
