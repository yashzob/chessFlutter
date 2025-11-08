import 'package:flutter/material.dart';
import '../services/websocket_service.dart';
import '../providers/auth_provider.dart';
import 'game_screen.dart';
import 'package:provider/provider.dart';

enum LobbyStatus { waiting, matched }

class LobbyScreen extends StatefulWidget {
  const LobbyScreen({super.key});

  @override
  State<LobbyScreen> createState() => _LobbyScreenState();
}

class _LobbyScreenState extends State<LobbyScreen> {
  late WebSocketService _wsService;
  LobbyStatus _status = LobbyStatus.waiting;
  int? _gameId;

  @override
  void initState() {
    super.initState();
    _wsService = WebSocketService();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final token = authProvider.token;
    if (token != null) {
      // Use 10.0.2.2 for Android emulator to access host machine
      _wsService.connect('ws://10.0.2.2:8000/ws/matchmaking/?token=$token');
      _wsService.onMessage = (message) {
        final data = message.toString();
        if (data.contains('matched')) {
          final gameId = RegExp(r'"game_id":\s*(\d+)').firstMatch(data)?.group(1);
          setState(() {
            _status = LobbyStatus.matched;
            _gameId = int.tryParse(gameId ?? '');
          });
          if (_gameId != null) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => GameScreen(gameId: _gameId!),
              ),
            );
          }
        }
      };
      // Wait for connection to be ready before sending
      Future.delayed(const Duration(milliseconds: 500), () {
        _wsService.send('{"action": "find_match"}');
      });
    } else {
      // Handle no token case, perhaps navigate back to login
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _wsService.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Waiting for Match')),
      body: Center(
        child: _status == LobbyStatus.waiting
            ? const CircularProgressIndicator()
            : const Text('Matched! Starting game...'),
      ),
    );
  }
}
