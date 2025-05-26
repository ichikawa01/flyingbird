import 'dart:async';

import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:myapp/components/background.dart';
import 'package:myapp/components/ball.dart';
import 'package:myapp/components/ball_manager.dart';
import 'package:myapp/components/score.dart';
// import 'package:myapp/main.dart';
import 'components/bird.dart';
import 'components/ground.dart';
import 'package:myapp/constants.dart';


class FlappyBirdGame extends FlameGame with TapDetector, HasCollisionDetection {
  /*

  Basic Game Component
  - bird
  - background
  - ground
  - balls
  - score

  */

  late Bird bird;
  late Background background;
  late Ground ground;
  late BallManager ballManager;
  late ScoreText scoreText;

  /*

  LOAD

  */

  @override
  FutureOr<void> onLoad() {
    // load background
    background = Background(size);
    add(background);

    // load ground
    ground = Ground();
    add(ground);

    // load ball manager
    ballManager = BallManager();
    add(ballManager);
    
    // load bird
    bird = Bird();
    add(bird);

    // load score
    scoreText = ScoreText();
    add(scoreText);

  }

  /*

  TAP

  */

  @override
  void onTap() {
    bird.flap();
  }

  /*

  SCORE

  */

  int score = 0;

  void increaseScore() {
    score += 1;
  }


  /*

  GAME OVER

  */

  bool isGameOver = false;

  void gameOver() {
    if (isGameOver) return;

    isGameOver = true;
    pauseEngine();

    // リセット
    showDialog(
    context: buildContext!,
    barrierDismissible: false,
    builder: (context) => Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 上部: Game Over 画像
          Image.asset('assets/images/gameover.png'),

          const SizedBox(height: 160),

          // 中央: スコア画像に重ねてテキスト表示
          Stack(
            alignment: Alignment.center,
            children: [
              Image.asset('assets/images/result.png'), // ベースの画像
              Column(
                crossAxisAlignment: CrossAxisAlignment.end, // ← 数字を右寄せ
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 220, top: 20), // ← ここで右にずらす
                    child: Text(
                      '$score',
                      style: const TextStyle(
                        fontFamily: 'PixelFont',
                        fontSize: 26,
                        color: Colors.deepOrange,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 220, top: 25),
                    child: Text(
                      '${scoreText.currentHighScore}',
                      style: const TextStyle(
                        fontFamily: 'PixelFont',
                        fontSize: 26,
                        color: Colors.deepOrange,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 80),

          // 下部: Restart ボタン画像（押せる）
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
              resetGame();
            },
            child: Image.asset('assets/images/restart.png'),
          ),
        ],
      ),
    ),
  );

  }

  void resetGame() {
    isGameOver = false;
    bird.position = Vector2(birdStartX, birdStartY);
    bird.velocity = 0;
    score = 0;

    children.whereType<Ball>().forEach((ball) => ball.removeFromParent());
    resumeEngine();
  }

}