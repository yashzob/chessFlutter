import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../widgets/chessboard.dart';
import '../services/websocket_service.dart';

class GameScreen extends StatefulWidget {
  final int gameId;
  final String? token; // token is optional now

  const GameScreen({super.key, required this.gameId, this.token});

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late WebSocketService _wsService;

  @override
  void initState() {
    super.initState();
  _wsService = WebSocketService();
    // Defer connecting until after first frame so context and platform are ready
    WidgetsBinding.instance.addPostFrameCallback((_) => _connect());
  }

  void _connect() {
    // Choose host depending on platform: Android emulator uses 10.0.2.2 to reach host machine
    final host = kIsWeb ? '127.0.0.1' : (Platform.isAndroid ? '10.0.2.2' : '127.0.0.1');
    final scheme = 'ws'; // change to 'wss' if your server requires TLS

    final query = <String, String>{};
    if (widget.token != null && widget.token!.isNotEmpty) {
      query['token'] = widget.token!;
    }

    final uri = Uri(
      scheme: scheme,
      host: host,
      port: 8000,
      path: '/ws/game/${widget.gameId}/',
      queryParameters: query.isEmpty ? null : query,
    );

    try {
  debugPrint('GameScreen: connecting to $uri');
  _wsService.connect(uri.toString());
    } catch (e, st) {
      debugPrint('GameScreen: websocket connect failed: $e\n$st');
    }
  }

  @override
  void dispose() {
    try {
      _wsService.disconnect();
    } catch (e) {
      // ignore errors during dispose
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chess Game')),
      body: Column(
        children: [
          const Expanded(child: ChessBoard()),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Credits used: 0/3'), // Placeholder for credits
          ),
        ],
      ),
    );
  }
}
