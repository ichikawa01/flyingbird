import 'dart:async';
// import 'dart:ui';
// import 'package:flame/effects.dart';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:myapp/constants.dart';

import '../game.dart';

class Ball extends SpriteComponent with CollisionCallbacks, HasGameReference<FlappyBirdGame> {

  late Sprite darkSprite;
  late Sprite brightSprite;
  
  bool hit = false;

  Ball(Vector2 position, Vector2 size)
      : super(
          position: position,
          size: size,
        );

  /*

  LOAD
   
  */

  @override
  Future<void> onLoad() async {
    darkSprite = await Sprite.load('chochin_dark.png');
    brightSprite = await Sprite.load('chochin_bright.png');
    sprite = darkSprite;
    add(CircleHitbox());
  }

  /*

  APDATE
  
  */

  @override
  void update(double dt) {
    position.x -= groundScroolingSpeed * dt;

    // スコアを更新する
    if (position.x + size.x < game.bird.position.x && !hit) {
      game.gameOver();
    }

    if (position.x + size.x <= 0) {
      removeFromParent();
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (!hit && other == game.bird) {
      hit = true;

      playHitEffect();

      game.increaseScore();
    }
    super.onCollision(intersectionPoints, other);
  }

  void playHitEffect() {
    sprite = brightSprite;
  }
}