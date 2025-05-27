import 'package:flame/game.dart';
import 'package:flutter/material.dart';
// import 'homepage.dart';
import 'game.dart';



void main() {
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flappy Bird',
      debugShowCheckedModeBanner: false,
      home: GameWidget(game: FlappyBirdGame()),
    );
  }
}
