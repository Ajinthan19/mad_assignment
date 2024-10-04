class UserProfile {
  final String name;
  final String email;
  final String phone;

  UserProfile({required this.name, required this.email, required this.phone});

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
    );
  }
}
