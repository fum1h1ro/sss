#import "Game.h"
#import "Background.h"

@interface EffectRevolver : GameInstanceRevolver {
    NSString* _effname;
}
- (id)initWithNumOfStock:(u32)num effectName:(NSString*)effname;
@end

@class Player;

@interface SceneMain : GameScene<GameBGNodeDelegate> {
    Background* _background;
    SKLabelNode* _score;
    NSDictionary* _groundenemytable;
}
@property (strong, readonly, nonatomic) EffectRevolver* shotReflectEffect;
@property (strong, readonly, nonatomic) EffectRevolver* smallBombEffect;
@property (weak, nonatomic) Player* player;
@end


@interface PlayerShot : GameObject {
    SKSpriteNode* _sprite;
    f32 _speed;
}
- (id)initWithPos:(CGPoint)pos dir:(f32)dir speed:(f32)speed;
@end

@interface PlayerShotEffect : GameObject {
}
- (id)initWithPos:(CGPoint)pos dir:(f32)dir;
@end


@interface Player : GameObject {
    SKSpriteNode* _sprite;
    f32 _reload, _infinity;
    s32 _power;
}
@property (assign, nonatomic) CGRect availableArea;
- (BOOL)damage;
@end

