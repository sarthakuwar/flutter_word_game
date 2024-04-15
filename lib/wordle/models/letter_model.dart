import'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wordle/app/app_colors.dart';
enum LetterStatus{initial,notInWord,InWord,Correct}

class Letter extends Equatable{



  const Letter({
    required this.val,
    this.status=LetterStatus.initial,
   });
factory Letter.empty()=> const Letter(val: "");
  final String val;
  final LetterStatus status;

  Color get Backgroundcolor {
    switch (status) {
      case LetterStatus.initial:
        return Colors.transparent;
      case LetterStatus.Correct:
        return correctColor;
      case LetterStatus.notInWord:
        return notInWordColor;
      case LetterStatus.InWord:
        return InWordColor;
    }
  }
    Color get BorderColor{
       switch(status){
         case LetterStatus.initial:
           return Colors.grey;
         default:
           return Colors.transparent;
       }

    }
    Letter copyWith({
      String? val,
      LetterStatus? status,
    }){
    return Letter(
      val: val ?? this.val,
      status: status ?? this.status,

    );



    }
@override
  List<Object?> get props=>[val,status];

}