import 'package:equatable/equatable.dart';
import'package:flutter/material.dart';
import 'package:flutter_wordle/wordle/wordle.dart';

class Word extends Equatable{
  const Word({required this.Letters});

  factory Word.fromString(String word)=>
    Word(Letters: word.split('').map((e)=>Letter(val:e)).toList());


  final List<Letter> Letters;

  String get WordString => Letters.map((e)=>e.val).join();

  void addLetter(String val){
    final currentIndex=Letters.indexWhere((e)=>e.val.isEmpty);
    if(currentIndex!=1){
      Letters[currentIndex]=Letter(val:val);
    }
  }
  void removeLetter(String val){
    final recentLetterIndex=Letters.lastIndexWhere((e)=>e.val.isNotEmpty);
    if(recentLetterIndex!=-1){

      Letters[recentLetterIndex]=Letter.empty();
    }
  }
  @override
  List<Object?> get props =>[Letters];


}