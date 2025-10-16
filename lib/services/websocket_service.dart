import 'package:web_socket_channel/web_socket_channel.dart';

typedef MessageCallback = void Function(dynamic message);

class WebSocketService {
  WebSocketChannel? _channel;
  MessageCallback? onMessage;

  void connect(String url) {
    _channel = WebSocketChannel.connect(Uri.parse(url));
    _channel!.stream.listen((message) {
      if (onMessage != null) {
        onMessage!(message);
      }
      // Optionally, print for debug
      print('Received: $message');
    });
  }

  void send(String message) {
    _channel?.sink.add(message);
  }

  void disconnect() {
    _channel?.sink.close();
  }
}
