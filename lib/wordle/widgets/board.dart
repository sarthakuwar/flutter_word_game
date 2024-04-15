import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wordle/wordle/wordle.dart';

class Board extends StatelessWidget {
  const Board({
    Key? key,
    required this.board,
    required this.flipCardKeys,
  }) : super(key: key);

  final List<Word> board;
  final List<List<GlobalKey<FlipCardState>>> flipCardKeys;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: board.asMap().entries.map((entry) {
        final i = entry.key;
        final word = entry.value;
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: word.Letters.asMap().entries.map((entry) {
            final j = entry.key;
            final letter = entry.value;
            return FlipCard(
              key: flipCardKeys[i][j],
              flipOnTouch: false,
              direction: FlipDirection.VERTICAL,
              front: BoardTile(
                letter: Letter(
                  val: letter.val,
                  status: LetterStatus.initial,
                ),
              ),
              back: BoardTile(letter: letter),
            );
          }).toList(),
        );
      }).toList(),
    );
  }
}
