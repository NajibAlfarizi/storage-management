// lib/models/login_model.dart
class LoginModel {
  final String username;
  final String email;

  LoginModel({required this.username, required this.email});

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(
      username: json['username'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
    };
  }
}
