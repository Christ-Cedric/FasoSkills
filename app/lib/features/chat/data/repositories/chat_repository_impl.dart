import '../../../../core/errors/failure.dart';
import '../../../../core/errors/result.dart';
import '../../../../core/network/api_client.dart';
import '../../domain/models/message.dart';
import '../../domain/repositories/chat_repository.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ApiClient _apiClient;

  ChatRepositoryImpl({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  @override
  Future<Result<ChatConversation>> startOrGetConversation({
    required String recipientId,
    String? initialMessage,
  }) async {
    try {
      final res = await _apiClient.post(
        '/chat/conversations',
        body: {
          'recipientId': recipientId,
          if (initialMessage != null) 'initialMessage': initialMessage,
        },
      );
      return Success(ChatConversation.fromJson(res['data']));
    } on Failure catch (f) {
      return FailureResult(f);
    } catch (e) {
      return FailureResult(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<List<ChatConversation>>> getConversations() async {
    try {
      final res = await _apiClient.get('/chat/conversations');
      final List list = res['data'] ?? [];
      return Success(list.map((e) => ChatConversation.fromJson(e)).toList());
    } on Failure catch (f) {
      return FailureResult(f);
    } catch (e) {
      return FailureResult(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<List<ChatMessage>>> getMessages(String conversationId) async {
    try {
      final res = await _apiClient.get('/chat/conversations/$conversationId/messages');
      final List list = res['data'] ?? [];
      return Success(list.map((e) => ChatMessage.fromJson(e)).toList());
    } on Failure catch (f) {
      return FailureResult(f);
    } catch (e) {
      return FailureResult(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<ChatMessage>> sendMessage({
    required String conversationId,
    required String text,
  }) async {
    try {
      final res = await _apiClient.post(
        '/chat/conversations/$conversationId/messages',
        body: {'text': text},
      );
      return Success(ChatMessage.fromJson(res['data']));
    } on Failure catch (f) {
      return FailureResult(f);
    } catch (e) {
      return FailureResult(ServerFailure(e.toString()));
    }
  }
}
