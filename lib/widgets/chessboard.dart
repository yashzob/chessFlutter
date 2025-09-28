import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess_lib;

class ChessBoard extends StatefulWidget {
  const ChessBoard({super.key});

  @override
  _ChessBoardState createState() => _ChessBoardState();
}

class _ChessBoardState extends State<ChessBoard> {
  late chess_lib.Chess chess;
  String? selectedSquare;

  final Map<String, String> pieceSymbols = {
    'r': '♜', 'n': '♞', 'b': '♝', 'q': '♛', 'k': '♚', 'p': '♟',
    'R': '♖', 'N': '♘', 'B': '♗', 'Q': '♕', 'K': '♔', 'P': '♙',
  };

  @override
  void initState() {
    super.initState();
    chess = chess_lib.Chess();
  }

  String _pieceChar(chess_lib.Piece piece) {
    String typeChar;
    switch (piece.type) {
      case chess_lib.PieceType.PAWN:
        typeChar = 'p';
        break;
      case chess_lib.PieceType.ROOK:
        typeChar = 'r';
        break;
      case chess_lib.PieceType.KNIGHT:
        typeChar = 'n';
        break;
      case chess_lib.PieceType.BISHOP:
        typeChar = 'b';
        break;
      case chess_lib.PieceType.QUEEN:
        typeChar = 'q';
        break;
      case chess_lib.PieceType.KING:
        typeChar = 'k';
        break;
      default:
        typeChar = '';
    }
    return piece.color == chess_lib.Color.WHITE ? typeChar.toUpperCase() : typeChar;
  }

  String _squareFromRowCol(int row, int col) {
    int file = col;
    int rank = 7 - row;
    return String.fromCharCode('a'.codeUnitAt(0) + file) + (rank + 1).toString();
  }

  void _onSquareTap(int row, int col) {
    String tappedSquare = _squareFromRowCol(row, col);
    setState(() {
      if (selectedSquare == null) {
        if (chess.get(tappedSquare) != null) {
          selectedSquare = tappedSquare;
        }
      } else {
        if (selectedSquare == tappedSquare) {
          selectedSquare = null;
        } else {
          if (chess.move({'from': selectedSquare, 'to': tappedSquare})) {
            // Move successful
            // TODO: Send move to backend
          }
          selectedSquare = null;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(8, (row) {
        return Expanded(
          child: Row(
            children: List.generate(8, (col) {
              bool isBlack = (row + col) % 2 == 1;
              String square = _squareFromRowCol(row, col);
              bool isSelected = selectedSquare == square;
              var pieceObj = chess.get(square);
              String display = pieceObj != null ? pieceSymbols[_pieceChar(pieceObj)] ?? '' : '';
              return Expanded(
                child: GestureDetector(
                  onTap: () => _onSquareTap(row, col),
                  child: Container(
                    color: isSelected ? Colors.blue : (isBlack ? Colors.brown : Colors.white),
                    child: Center(
                      child: Text(
                        display,
                        style: TextStyle(
                          fontSize: 24,
                          color: isBlack ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        );
      }),
    );
  }
}
