import 'package:flutter/material.dart';
import '../widgets/chessboard.dart';
import '../services/websocket_service.dart';


class GameScreen extends StatefulWidget {
  final int gameId;
  const GameScreen({super.key, required this.gameId});

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late WebSocketService _wsService;

  @override
  void initState() {
    super.initState();
    _wsService = WebSocketService();
    _wsService.connect('ws://localhost:8000/ws/game/${widget.gameId}/');
  }

  @override
  void dispose() {
    _wsService.disconnect();
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
            child: Text('Credits used: 0/3'),  // Placeholder for credits
          ),
        ],
      ),
    );
  }
}
