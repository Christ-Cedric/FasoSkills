import 'package:equatable/equatable.dart';

class ServiceRequest extends Equatable {
  final String id;
  final String clientId;
  final String categoryId;
  final String title;
  final String description;
  final String city;
  final String address;
  final List<String> photos;
  final String
      status; // 'pending' | 'accepted' | 'in_progress' | 'completed' | 'cancelled'
  final String? acceptedQuoteId;
  final DateTime? createdAt;

  const ServiceRequest({
    required this.id,
    required this.clientId,
    required this.categoryId,
    required this.title,
    required this.description,
    required this.city,
    this.address = '',
    this.photos = const [],
    this.status = 'pending',
    this.acceptedQuoteId,
    this.createdAt,
  });

  ServiceRequest copyWith({
    String? id,
    String? clientId,
    String? categoryId,
    String? title,
    String? description,
    String? city,
    String? address,
    List<String>? photos,
    String? status,
    String? acceptedQuoteId,
    DateTime? createdAt,
  }) {
    return ServiceRequest(
      id: id ?? this.id,
      clientId: clientId ?? this.clientId,
      categoryId: categoryId ?? this.categoryId,
      title: title ?? this.title,
      description: description ?? this.description,
      city: city ?? this.city,
      address: address ?? this.address,
      photos: photos ?? this.photos,
      status: status ?? this.status,
      acceptedQuoteId: acceptedQuoteId ?? this.acceptedQuoteId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory ServiceRequest.fromJson(Map<String, dynamic> json) {
    return ServiceRequest(
      id: json['id'] ?? json['_id'] ?? '',
      clientId: json['clientId'] is Map
          ? (json['clientId']['id'] ?? json['clientId']['_id'] ?? '')
          : (json['clientId'] ?? ''),
      categoryId: json['categoryId'] is Map
          ? (json['categoryId']['id'] ?? json['categoryId']['_id'] ?? '')
          : (json['categoryId'] ?? ''),
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      city: json['city'] ?? '',
      address: json['address'] ?? '',
      photos: (json['photos'] as List?)?.map((e) => e.toString()).toList() ??
          const [],
      status: json['status'] ?? 'pending',
      acceptedQuoteId: json['acceptedQuoteId']?.toString(),
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'clientId': clientId,
        'categoryId': categoryId,
        'title': title,
        'description': description,
        'city': city,
        'address': address,
        'photos': photos,
        'status': status,
        'acceptedQuoteId': acceptedQuoteId,
      };

  @override
  List<Object?> get props => [
        id,
        clientId,
        categoryId,
        title,
        description,
        city,
        address,
        photos,
        status,
        acceptedQuoteId,
      ];
}
