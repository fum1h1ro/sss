#import "Game.h"
#import "Background.h"

@interface SceneMain : GameScene<GameBGNodeDelegate> {
    Background* _background;
}

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

