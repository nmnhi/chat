import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  final _storage = FlutterSecureStorage();

  // Singleton instance
  static final SocketService _instance = SocketService._internal();

  // Getter to access the singleton instance
  factory SocketService() => _instance;

  // Socket instance
  late IO.Socket _socket;

  // Private constructor for singleton
  SocketService._internal() {
    initSocket();
  }

  Future<void> initSocket() async {
    String token = await _storage.read(key: "token") ?? '';

    _socket = IO.io(
      'http://localhost:6000',
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .setExtraHeaders({"Authorization": "Bearer $token"})
          .build(),
    );

    _socket.connect();

    _socket.onConnect((_) {
      print("Socket connected: ${_socket.id}");
    });

    _socket.onDisconnect((_) {
      print('Socket disconnected');
    });
  }

  IO.Socket get socket => _socket;
}
