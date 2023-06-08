import 'dart:developer';

import 'package:web_socket_client/web_socket_client.dart';

class WsClient {
  // Trigger a timeout if establishing a connection exceeds 10s.
  static const timeout = Duration(seconds: 10);

  // Create a WebSocket client.
  final socket = WebSocket(Uri.parse('ws://localhost:8080'), timeout: timeout);

  void connect() async {
    // Listen to messages from the server.
    socket.messages.listen((message) {
      // Handle incoming messages.
      log(message);
    });
  }

  void send() async {
    // Send a message to the server.
    socket.send('ping');
  }

  void close() async {
    // Close the connection.
    socket.close();
  }
}
