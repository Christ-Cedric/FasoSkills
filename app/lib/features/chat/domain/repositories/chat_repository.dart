import '../../../../core/errors/result.dart';
import '../models/message.dart';

abstract class ChatRepository {
  Future<Result<ChatConversation>> startOrGetConversation({
    required String recipientId,
    String? initialMessage,
  });
  Future<Result<List<ChatConversation>>> getConversations();
  Future<Result<List<ChatMessage>>> getMessages(String conversationId);
  Future<Result<ChatMessage>> sendMessage({
    required String conversationId,
    required String text,
  });
}
