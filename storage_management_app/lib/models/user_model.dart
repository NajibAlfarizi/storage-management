// user_model.dart

class UserModel {
  final int id;
  final String username;
  final String image;

  UserModel({required this.id, required this.username, required this.image});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      username: json['username'],
      image: json['image'],
    );
  }
}
