import 'package:flame/components.dart';

class StartOverlay extends SpriteComponent {
  StartOverlay(Vector2 gameSize)
      : super(
          size: Vector2(200, 140),
          position: Vector2(
            (gameSize.x - 200) / 2,
            gameSize.y / 2 + 20,
          ),
        );

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('tap.png');
  }
}
