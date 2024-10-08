class User {
  final String id;
  final String first_name;
  final String last_name;
  final String email;
  final String dob;
  final String phone;
  final String avatar_id;
  final String full_name;
  final String avatar_url;

  User({
    required this.id,
    required this.first_name,
    required this.last_name,
    required this.email,
    required this.dob,
    required this.phone,
    required this.avatar_id,
    required this.full_name,
    required this.avatar_url,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id']?.toString() ?? '',
      first_name: json['first_name']?.toString() ?? '',
      last_name: json['last_name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      dob: json['dob']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      avatar_id: json['avatar_id']?.toString() ?? '',
      full_name: json['full_name']?.toString() ?? '',
      avatar_url: json['avatar_url']?.toString() ?? '',
    );
  }
}
