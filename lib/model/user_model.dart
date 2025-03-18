class User {
  final String id;
  final String name;
  final String email;
  final String password;
  final DateTime dateOfBirth;
  final String role;
  final String? googleId;
  final String? otp;
  final DateTime? otpExpires;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? refreshToken;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.dateOfBirth,
    required this.role,
    this.googleId,
    this.otp,
    this.otpExpires,
    required this.createdAt,
    required this.updatedAt,
    this.refreshToken,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      name: json['name'],
      email: json['email'],
      password: json['password'],
      dateOfBirth: DateTime.parse(json['dateOfBirth']),
      role: json['who'],
      googleId: json['googleId'],
      otp: json['otp'],
      otpExpires: json['otpExpires'] != null ? DateTime.parse(json['otpExpires']) : null,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      refreshToken: json['refreshToken'],
    );
  }
}