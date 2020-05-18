class User {
  final int id;
  final String firstName;
  final String lastName;
  final String country;
  final String state;
  final String county;
  final String email;
  final DateTime createdAt;

  User({
    this.id,
    this.firstName,
    this.lastName,
    this.country,
    this.state,
    this.county,
    this.email,
    this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    final createdAt = DateTime.parse(json['createdAt']);

    return User(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      country: json['country'],
      state: json['state'],
      county: json['county'],
      email: json['email'],
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": this.id,
      "firstName": this.firstName,
      "lastName": this.lastName,
      "country": this.country,
      "state": this.state,
      "county": this.county,
      "email": this.email,
      "createdAt": createdAt.toString(),
    };
  }
}
