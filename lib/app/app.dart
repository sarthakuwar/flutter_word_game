import 'package:flutter/material.dart';
import 'package:flutter_wordle/wordle/wordle.dart';
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title:"flutter wordle app",
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(scaffoldBackgroundColor: Colors.black),
      home:const WordleScreen(),



    );
  }
}
