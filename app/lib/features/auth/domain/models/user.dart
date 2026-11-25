import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String email;
  final String fullName;
  final String? phone;
  final String role; // 'client' | 'artisan' | 'admin'
  final bool isVerified;
  final String? artisanProfileId;

  const User({
    required this.id,
    required this.email,
    required this.fullName,
    this.phone,
    required this.role,
    this.isVerified = false,
    this.artisanProfileId,
  });

  bool get isArtisan => role == 'artisan';
  bool get isClient => role == 'client';
  bool get isAdmin => role == 'admin';

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? json['_id'] ?? '',
      email: json['email'] ?? '',
      fullName: json['fullName'] ?? '',
      phone: json['phone'],
      role: json['role'] ?? 'client',
      isVerified: json['isVerified'] ?? false,
      artisanProfileId: json['artisanProfileId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'fullName': fullName,
      'phone': phone,
      'role': role,
      'isVerified': isVerified,
      'artisanProfileId': artisanProfileId,
    };
  }

  @override
  List<Object?> get props =>
      [id, email, fullName, phone, role, isVerified, artisanProfileId];
}
