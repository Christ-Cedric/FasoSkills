import 'package:equatable/equatable.dart';

class ChatMessage extends Equatable {
  final String id;
  final String conversationId;
  final String senderId;
  final String? senderName;
  final String text;
  final bool isRead;
  final DateTime? createdAt;

  const ChatMessage({
    required this.id,
    required this.conversationId,
    required this.senderId,
    this.senderName,
    required this.text,
    this.isRead = false,
    this.createdAt,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    String? senderName;
    if (json['senderId'] is Map) {
      senderName = json['senderId']['fullName'];
    }

    return ChatMessage(
      id: json['id'] ?? json['_id'] ?? '',
      conversationId: json['conversationId']?.toString() ?? '',
      senderId: json['senderId'] is Map
          ? (json['senderId']['id'] ?? json['senderId']['_id'] ?? '')
          : (json['senderId']?.toString() ?? ''),
      senderName: senderName,
      text: json['text'] ?? '',
      isRead: json['isRead'] ?? false,
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt']) : null,
    );
  }

  @override
  List<Object?> get props => [id, conversationId, senderId, text, isRead, createdAt];
}

class ChatConversation extends Equatable {
  final String id;
  final List<dynamic> participants;
  final String lastMessage;
  final DateTime? lastMessageAt;

  const ChatConversation({
    required this.id,
    required this.participants,
    this.lastMessage = '',
    this.lastMessageAt,
  });

  factory ChatConversation.fromJson(Map<String, dynamic> json) {
    return ChatConversation(
      id: json['id'] ?? json['_id'] ?? '',
      participants: json['participants'] is List ? json['participants'] : [],
      lastMessage: json['lastMessage'] ?? '',
      lastMessageAt: json['lastMessageAt'] != null
          ? DateTime.tryParse(json['lastMessageAt'])
          : null,
    );
  }

  @override
  List<Object?> get props => [id, participants, lastMessage, lastMessageAt];
}
