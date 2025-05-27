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
import 'components/start_overlay.dart';
import 'package:flame_audio/flame_audio.dart';




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
  BallManager? ballManager;
  late ScoreText scoreText;
  late StartOverlay startOverlay;



  /*

  LOAD

  */

  bool isStarted = false;

  @override
  Future<void> onLoad() async{
    // BGMとSEを事前読み込み
    await FlameAudio.audioCache.loadAll([
      'bgm.mp3',
      // 'jump.mp3',
      // 'gameover.mp3',
      // 'score.mp3',
    ]);

    FlameAudio.bgm.initialize(); // BGMエンジン初期化
    FlameAudio.bgm.play('bgm.mp3', volume: 0.5); // BGM再生（ループ）

    // load background
    background = Background(size);
    add(background);

    // load ground
    ground = Ground();
    add(ground);
    
    // load bird
    bird = Bird();
    add(bird);

    startOverlay = StartOverlay(size);
    add(startOverlay);
  }

  /*

  TAP

  */

  @override
  void onTap() {
    if (!isStarted) {
      // 初回タップでゲーム開始！
      isStarted = true;

      startOverlay.removeFromParent();

      // スコアとボール開始
      ballManager?.removeFromParent();
      ballManager = BallManager();
      add(ballManager!);
      
      scoreText = ScoreText();
      add(scoreText);
    }

    if (!isGameOver) {
      bird.flap();
    }
  }

  /*

  SCORE

  */

  int score = 0;

  void increaseScore() {
    score += 1;
    // FlameAudio.play('score.mp3');
  }


  /*

  GAME OVER

  */

  bool isGameOver = false;

  void gameOver() {
    if (isGameOver) return;

    // FlameAudio.play('gameover.mp3');
    isGameOver = true;
    pauseEngine();

    bool showGameOver = false;
    bool showScoreBoard = false;
    bool showButtons = false;

    showDialog(
      context: buildContext!,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            Future.microtask(() async {
              await Future.delayed(Duration(milliseconds: 300));
              setState(() => showGameOver = true);
              await Future.delayed(Duration(milliseconds: 500));
              setState(() => showScoreBoard = true);
              await Future.delayed(Duration(milliseconds: 500));
              setState(() => showButtons = true);
            });

            return Dialog(
              backgroundColor: Colors.transparent,
              insetPadding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedOpacity(
                    duration: Duration(milliseconds: 30),
                    opacity: showGameOver ? 1.0 : 0.0,
                    child: Image.asset('assets/images/gameover.png'),
                  ),

                  const SizedBox(height: 120),

                  AnimatedOpacity(
                    duration: Duration(milliseconds: 30),
                    opacity: showScoreBoard ? 1.0 : 0.0,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Image.asset('assets/images/result.png'),
                        Padding(
                          padding: const EdgeInsets.only(top: 1),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                children: [
                                  const Text('SCORE', style: TextStyle(fontFamily: 'PixelFont', fontSize: 22, color: Color.fromARGB(255, 202, 19, 6))),
                                  Text('$score', style: const TextStyle(fontFamily: 'PixelFont', fontSize: 26, color: Color.fromARGB(255, 202, 19, 6))),
                                ],
                              ),
                              const SizedBox(width: 40),
                              Column(
                                children: [
                                  const Text('BEST', style: TextStyle(fontFamily: 'PixelFont', fontSize: 22, color: Color.fromARGB(255, 202, 19, 6))),
                                  Text('${scoreText.currentHighScore}', style: const TextStyle(fontFamily: 'PixelFont', fontSize: 26, color: Color.fromARGB(255, 202, 19, 6))),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 80),

                  AnimatedOpacity(
                    duration: Duration(milliseconds: 30),
                    opacity: showButtons ? 1.0 : 0.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                            resetGame();
                          },
                          child: Image.asset('assets/images/restart.png'),
                        ),
                        const SizedBox(width: 20),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                            resetGame();
                          },
                          child: Image.asset('assets/images/ranking.png'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );

  }


  void resetGame() {
    isGameOver = false;
    isStarted = false;
    add(startOverlay);
    bird.position = Vector2(birdStartX, birdStartY);
    bird.velocity = 0;
    score = 0;
    scoreText.removeFromParent();

    children.whereType<Ball>().forEach((ball) => ball.removeFromParent());
    resumeEngine();
  }

}