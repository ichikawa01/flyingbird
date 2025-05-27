import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flame/components.dart';
import 'package:myapp/game.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ScoreText extends TextComponent with HasGameReference<FlappyBirdGame> {

  int highScore = 0;

  ScoreText() 
  : super(
    text: '0',
    textRenderer: TextPaint(
      style: TextStyle(
        fontFamily: 'PixelFont',
        fontSize: 48,
        color: const Color.fromARGB(255, 195, 23, 11),
      ),
    ),
  );


  @override
  FutureOr<void> onLoad() async{
    await super.onLoad();

    position = Vector2(
      (game.size.x - size.x) / 2,
      100,
    );
    await loadHighScore();
  }

  @override
  void update(double dt) {
    super.update(dt);
    final newScore = game.score;

    if (newScore > highScore) {
      highScore = newScore;
      saveHighScore();
    }

    text = '$newScore';
  }


  Future<void> loadHighScore() async {
    final prefs = await SharedPreferences.getInstance();
    highScore = prefs.getInt('highScore') ?? 0;
  }

   Future<void> saveHighScore() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('highScore', highScore);
  }

  int get currentHighScore => highScore;

}