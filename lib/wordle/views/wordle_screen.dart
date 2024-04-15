import 'dart:async';

import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wordle/app/app_colors.dart';
import 'package:flutter_wordle/wordle/wordle.dart';
import 'dart:math';
enum GameStatus {playing,submitting,lost, won}
class WordleScreen extends StatefulWidget{
  const WordleScreen({Key? key}):super(key:key );

  @override
  _WordleScreenState createState()=> _WordleScreenState();
}

class _WordleScreenState extends State<WordleScreen>{
  GameStatus _gameStatus=GameStatus.playing;
  final List<Word> _board=List.generate(
    6,
     (_)=> Word(Letters:List.generate(5,(_) => Letter.empty())),

      );
  final List<List<GlobalKey<FlipCardState>>>_flipCardKeys=List.generate(
    6,
      (_) => List.generate(5,(_)=>GlobalKey<FlipCardState>())
  );
  int _currentWordIndex=0;
  Word? get _currentWord =>
      _currentWordIndex < _board.length? _board[_currentWordIndex]: null;
  Word _solution =Word.fromString(
    fiveLetterWords[Random().nextInt(fiveLetterWords.length)].toUpperCase()
  );

  final Set<Letter> _keyboardLetters={};



  @override

  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'WORDLE',
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            letterSpacing: 4,
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Board(board: _board,flipCardKeys:_flipCardKeys),
          const SizedBox(height: 80,),
          Keyboard(
            onKeyTapped: onKeyTapped,
            onDeleteTapped:()=> onDeleteTapped,
            onEnterTapped:()=> onEnterTapped,
            letters:_keyboardLetters,
          )
        ],
      ),
    );
  }
  void onKeyTapped(String val) {
    if (_gameStatus == GameStatus.playing) {
      setState(() => _currentWord?.addLetter(val));
      _currentWordIndex +=1;
    }
  }

  void onDeleteTapped(String val) {
    if (_gameStatus == GameStatus.playing) {
      setState(() => _currentWord?.removeLetter(val));
    }
   }

  void onEnterTapped(String val) {
    if (_gameStatus == GameStatus.playing &&
        _currentWord != null &&
        !_currentWord!.Letters.contains(Letter.empty())) {
      _gameStatus = GameStatus.submitting;
      for (var i = 0; i < _currentWord!.Letters.length; i++) {
        final currentWordLetter = _currentWord!.Letters[i];
        final currentSolutionLetter = _solution.Letters[i];
        setState(() {
          if (currentSolutionLetter == currentWordLetter) {
            _currentWord!.Letters[i] =
                currentWordLetter.copyWith(status: LetterStatus.Correct);
          } else if (_solution.Letters.contains(currentWordLetter)) {
            _currentWord!.Letters[i] =
                currentWordLetter.copyWith(status: LetterStatus.InWord);
          } else {
            _currentWord!.Letters[i] =
                currentWordLetter.copyWith(status: LetterStatus.notInWord);
          }
        });
        Future.delayed(
          const Duration(milliseconds: 150),
              () => _flipCardKeys[_currentWordIndex][i].currentState?.toggleCard(),
        );
      }
      _checkIfWinOrLoss();
    }
  }

  void _checkIfWinOrLoss(){
    if(_currentWord!.WordString==_solution.WordString){
      _gameStatus=GameStatus.won;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          dismissDirection: DismissDirection.none,
          duration: const Duration(days: 1),
          backgroundColor: correctColor,
          content: const Text(
            'YOU WON',
            style: TextStyle(color: Colors.white),

          ),
          action: SnackBarAction(
            onPressed: _restart,
            textColor: Colors.white,
            label: 'play AGAIN',

          ),

        ),
      );
      }else if (_currentWordIndex+1>=_board.length){
      _gameStatus=GameStatus.lost;
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            dismissDirection: DismissDirection.none,
            duration: const Duration(days: 1),
            backgroundColor: Colors.redAccent[200],
            content: Text(
              'YOU LOST! Solution: ${_solution.WordString}',
              style: TextStyle(color: Colors.white),

            ),
            action: SnackBarAction(
              onPressed: _restart,
              textColor: Colors.white,
              label: 'play AGAIN',

            ),

          ),
      );
    } else {
      _gameStatus = GameStatus.playing;
    }

    _currentWordIndex +=1;
  }

  void _restart() {
    setState(() {
      _gameStatus = GameStatus.playing;
      _currentWordIndex = 0;
      _board
        ..clear()
        ..addAll(
          List.generate(
            6,
                (_) => Word(Letters: List.generate(5, (_) => Letter.empty())),
          ),
        );
      _solution = Word.fromString(
        fiveLetterWords[Random().nextInt(fiveLetterWords.length)].toUpperCase(),


      );
      _flipCardKeys
      ..clear()
      ..addAll(
        List.generate(6, (_) => List.generate(5,(_)=>GlobalKey<FlipCardState>()))
      );
      _keyboardLetters.clear();
    });
  }

}

