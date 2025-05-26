import 'dart:async';

import 'package:flame/components.dart';

class Background extends SpriteComponent {
  // 背景の位置とサイズを指定
  Background(Vector2 size) 
  : super(
    size: size,
    position: Vector2(0, 0),
  );

  @override
  FutureOr<void> onLoad() async {
    // 背景のスプライト画像を読み込む
    sprite = await Sprite.load('jap_back_1.png');
  }
}