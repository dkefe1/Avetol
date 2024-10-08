class Role {
  final String castables_type;
  final String role;

  Role({required this.castables_type, required this.role});

  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(
      castables_type: json['castables_type']?.toString() ?? '',
      role: json['role']?.toString() ?? '',
    );
  }
}
