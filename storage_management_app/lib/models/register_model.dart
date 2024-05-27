class RegisterModel {
  final String? username;
  final String? password;
  final String? image;

  RegisterModel({this.username, this.password, this.image});
  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
      'image': image,
    };
  }
}
