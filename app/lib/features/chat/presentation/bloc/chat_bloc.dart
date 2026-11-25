import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/network/ws_client.dart';
import '../../domain/models/message.dart';
import '../../domain/repositories/chat_repository.dart';

// Events
abstract class ChatEvent extends Equatable {
  const ChatEvent();
  @override
  List<Object?> get props => [];
}

class LoadMessages extends ChatEvent {
  final String conversationId;
  const LoadMessages(this.conversationId);
  @override
  List<Object?> get props => [conversationId];
}

class SendMessageSubmitted extends ChatEvent {
  final String conversationId;
  final String text;
  const SendMessageSubmitted({required this.conversationId, required this.text});
  @override
  List<Object?> get props => [conversationId, text];
}

class MessageReceivedFromWs extends ChatEvent {
  final ChatMessage message;
  const MessageReceivedFromWs(this.message);
  @override
  List<Object?> get props => [message];
}

// States
abstract class ChatState extends Equatable {
  const ChatState();
  @override
  List<Object?> get props => [];
}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class ChatLoaded extends ChatState {
  final List<ChatMessage> messages;
  final String conversationId;
  const ChatLoaded({required this.messages, required this.conversationId});
  @override
  List<Object?> get props => [messages, conversationId];
}

class ChatError extends ChatState {
  final String message;
  const ChatError(this.message);
  @override
  List<Object?> get props => [message];
}

// BLoC
class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepository _repository;
  final WebSocketClient _wsClient;
  StreamSubscription? _wsSubscription;

  ChatBloc({
    required ChatRepository repository,
    required WebSocketClient wsClient,
  })  : _repository = repository,
        _wsClient = wsClient,
        super(ChatInitial()) {
    on<LoadMessages>(_onLoadMessages);
    on<SendMessageSubmitted>(_onSendMessageSubmitted);
    on<MessageReceivedFromWs>(_onMessageReceivedFromWs);

    // Subscribe to WebSocket events in real-time!
    _wsSubscription = _wsClient.eventStream.listen((event) {
      if (event['event'] == 'message:received' && event['data'] != null) {
        final msg = ChatMessage.fromJson(event['data']);
        add(MessageReceivedFromWs(msg));
      }
    });
  }

  Future<void> _onLoadMessages(LoadMessages event, Emitter<ChatState> emit) async {
    emit(ChatLoading());
    _wsClient.joinRoom('conversation:${event.conversationId}');

    final result = await _repository.getMessages(event.conversationId);
    result.when(
      success: (messages) => emit(ChatLoaded(messages: messages, conversationId: event.conversationId)),
      failure: (failure) => emit(ChatError(failure.message)),
    );
  }

  Future<void> _onSendMessageSubmitted(SendMessageSubmitted event, Emitter<ChatState> emit) async {
    final result = await _repository.sendMessage(
      conversationId: event.conversationId,
      text: event.text,
    );

    result.when(
      success: (sentMsg) {
        if (state is ChatLoaded) {
          final current = (state as ChatLoaded).messages;
          if (!current.any((m) => m.id == sentMsg.id)) {
            emit(ChatLoaded(messages: [...current, sentMsg], conversationId: event.conversationId));
          }
        }
      },
      failure: (failure) {
        // Emit error notification if needed
      },
    );
  }

  void _onMessageReceivedFromWs(MessageReceivedFromWs event, Emitter<ChatState> emit) {
    if (state is ChatLoaded) {
      final loaded = state as ChatLoaded;
      if (loaded.conversationId == event.message.conversationId) {
        if (!loaded.messages.any((m) => m.id == event.message.id)) {
          emit(ChatLoaded(
            messages: [...loaded.messages, event.message],
            conversationId: loaded.conversationId,
          ));
        }
      }
    }
  }

  @override
  Future<void> close() {
    _wsSubscription?.cancel();
    return super.close();
  }
}
