import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
// import 'package:myapp/components/ball.dart';
import 'package:myapp/constants.dart';
import 'package:myapp/components/ground.dart';
import 'package:myapp/game.dart';

class Bird extends SpriteComponent with CollisionCallbacks {
  /*

  INIT BIRD

  */

  // スタート位置とサイズを指定
  Bird() : super(position: Vector2(birdStartX, birdStartY), size: Vector2(birdWidth, birdHeight));

  // 物理量の初期化
  double velocity = 0;

  /*

  LOAD

  */

  @override
  FutureOr<void> onLoad() async{
    // load bird sprite image
    sprite = await Sprite.load('origami.png');

    // 物理エンジンのためのコリジョンを追加
    add(RectangleHitbox());
  }

  /*

  JUMP / FLAP

  */

  void flap() {
    // ジャンプする
    velocity = jumpStrength;
  }

  /*

  UPDATE -> every second

  */
  @override
  void update(double dt) {
    // 速度が重力で変化
    velocity += gravity * dt;

    // 位置が速度で変化
    position.y += velocity * dt;

    // 画面外に出たら、位置をリセットする
    if (position.y < 0) {
      position.y = 0;
      velocity = 0;
    }

  }

  /*

  GAME OVER

  */

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);

    if (other is Ground) {
      (parent as FlappyBirdGame).gameOver();
    }
  }
}

