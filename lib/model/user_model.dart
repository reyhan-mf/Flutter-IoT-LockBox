class User {
  int userId;
  String name;
  String email;
  String phone;
  String membershipType;
  User(
      {required this.userId,
      required this.name,
      required this.email,
      required this.phone,
      required this.membershipType});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['user_id'],
      phone: json['phone'],
      name: json['name'],
      email: json['email'],
      membershipType: json['membershipType'],
    );
  }
}
