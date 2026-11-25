import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../config/app_config.dart';
import '../storage/secure_storage_service.dart';

class WebSocketClient {
  final SecureStorageService _storage;
  WebSocketChannel? _channel;
  final _eventController = StreamController<Map<String, dynamic>>.broadcast();
  bool _isConnected = false;

  WebSocketClient({SecureStorageService? storage})
      : _storage = storage ?? SecureStorageService();

  Stream<Map<String, dynamic>> get eventStream => _eventController.stream;
  bool get isConnected => _isConnected;

  Future<void> connect() async {
    if (_isConnected) return;

    try {
      final token = await _storage.getAccessToken();
      final uri = Uri.parse(
        token != null ? '${AppConfig.wsUrl}?token=$token' : AppConfig.wsUrl,
      );

      _channel = WebSocketChannel.connect(uri);
      _isConnected = true;

      _channel!.stream.listen(
        (data) {
          try {
            final Map<String, dynamic> parsed = jsonDecode(data.toString());
            _eventController.add(parsed);
          } catch (_) {}
        },
        onError: (err) {
          _isConnected = false;
        },
        onDone: () {
          _isConnected = false;
        },
      );
    } catch (_) {
      _isConnected = false;
    }
  }

  void joinRoom(String room) {
    if (_channel != null && _isConnected) {
      _channel!.sink.add(jsonEncode({'action': 'join_room', 'room': room}));
    }
  }

  void leaveRoom(String room) {
    if (_channel != null && _isConnected) {
      _channel!.sink.add(jsonEncode({'action': 'leave_room', 'room': room}));
    }
  }

  void disconnect() {
    _channel?.sink.close();
    _isConnected = false;
  }
}
