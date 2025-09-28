import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketService {
  WebSocketChannel? _channel;

  void connect(String url) {
    _channel = WebSocketChannel.connect(Uri.parse(url));
    _channel!.stream.listen((message) {
      // Handle incoming messages
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
