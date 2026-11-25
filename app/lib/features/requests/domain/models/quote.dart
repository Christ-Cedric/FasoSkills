import 'package:equatable/equatable.dart';

class Quote extends Equatable {
  final String id;
  final String requestId;
  final String artisanId;
  final String? artisanName;
  final double amount;
  final int estimatedDays;
  final String message;
  final String status; // 'pending' | 'accepted' | 'rejected'
  final DateTime? createdAt;

  const Quote({
    required this.id,
    required this.requestId,
    required this.artisanId,
    this.artisanName,
    required this.amount,
    required this.estimatedDays,
    this.message = '',
    this.status = 'pending',
    this.createdAt,
  });

  factory Quote.fromJson(Map<String, dynamic> json) {
    String? artisanName;
    if (json['artisanId'] is Map) {
      final user = json['artisanId']['userId'];
      if (user is Map) artisanName = user['fullName'];
    }

    return Quote(
      id: json['id'] ?? json['_id'] ?? '',
      requestId: json['requestId']?.toString() ?? '',
      artisanId: json['artisanId'] is Map
          ? (json['artisanId']['id'] ?? json['artisanId']['_id'] ?? '')
          : (json['artisanId']?.toString() ?? ''),
      artisanName: artisanName,
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      estimatedDays: json['estimatedDays'] ?? 1,
      message: json['message'] ?? '',
      status: json['status'] ?? 'pending',
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt']) : null,
    );
  }

  @override
  List<Object?> get props => [id, requestId, artisanId, amount, estimatedDays, message, status];
}
