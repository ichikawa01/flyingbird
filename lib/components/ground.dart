import 'dart:async';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:myapp/constants.dart';
import '../game.dart';

class Ground extends SpriteComponent with HasGameReference<FlappyBirdGame>, CollisionCallbacks {
  Ground() : super();

  /*

    LOAD
  
  */

  @override
  FutureOr<void> onLoad() async{
    size = Vector2(2 * game.size.x, groundHeight);
    position = Vector2(0, game.size.y - groundHeight);

    sprite = await Sprite.load('ground_block.png');


    // 物理エンジンのためのコリジョンを追加
    add(RectangleHitbox());
  }

  /*

    UPDATE -> every second
  
  */

  @override
  void update(double dt) {
    // 位置を更新する
    position.x -= groundScroolingSpeed * dt;

    // 画面外に出たら、位置をリセットする
    if (position.x + size.x / 2 <= 0) {
      position.x = 0;
    }
    
  }
}