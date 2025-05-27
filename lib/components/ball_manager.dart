import 'dart:math';

import 'package:flame/components.dart';
import 'package:myapp/constants.dart';
import 'package:myapp/components/ball.dart';
import 'package:myapp/game.dart';

class BallManager extends Component with HasGameReference<FlappyBirdGame>{
  /*

  UPDATE

  */

  double spawnTimer = 0;

  @override
  void update(double dt) {
    super.update(dt);
    if (!game.isStarted) {
      return;
    }


    spawnTimer += dt;

    if (spawnTimer > ballInterval) {
      spawnTimer = 0;
      spawnBall();

    }
  }

  /*

  SPAWN BALL

  */

  spawnBall() {
    final double screenHeight = game.size.y;
    final double ballY = minBallHeight + Random().nextDouble() * (screenHeight - groundHeight * 2 - minBallHeight);

    final ball = Ball(
      Vector2(game.size.x, ballY),
      Vector2(ballSize, ballSize*1.4),
    );

    game.add(ball);
  }

}