class User {
  final String username, email;
  final int id;
  final DateTime createdAt;

  User({this.id, this.username, this.email, this.createdAt});

  factory User.fromJson(Map<String, dynamic> json) {
    final createdAt = DateTime.parse(json['createdAt']);

    return User(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": this.id,
      "email": this.email,
      "username": username,
      "createdAt": createdAt.toString(),
    };
  }
}
