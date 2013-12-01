#import "Game.h"

@interface SceneMain : GameScene<GameBGNodeDelegate> {
    GameBGNode* _bg;
}
- (void)activateTile:(TMXTile*)tile;

@end


@interface PlayerShot : GameObject {
    SKSpriteNode* _sprite;
    f32 _speed;
}
- (id)initWithPos:(CGPoint)pos dir:(f32)dir speed:(f32)speed;
@end

@interface PlayerShotEffect : GameObject {
    SKEmitterNode* _emitter;
}
- (id)initWithPos:(CGPoint)pos dir:(f32)dir;
@end

@interface PlayerShotEffectRevolver : GameInstanceRevolver
@end

@interface Player : GameObject {
    SKSpriteNode* _sprite;
    f32 _reload;
}
@property (strong, readonly, nonatomic) PlayerShotEffectRevolver* revolver;
@end

@interface Enemy : GameObject {
    SKSpriteNode* _sprite;
    CGFloat _damage;
}
@end
