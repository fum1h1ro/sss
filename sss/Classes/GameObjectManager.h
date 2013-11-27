#import "GameCommon.h"
#import "GameUtil.h"
@class GameObjectManager;
@class GameScene;

@interface GameObjectManager : NSObject {
}
@property (strong, nonatomic) GameScene* scene;
@property (strong, nonatomic) NSMutableArray* active;
@property (strong, nonatomic) NSMutableArray* newbie;
@property (strong, nonatomic) NSMutableIndexSet* remove;
- (id)initWithScene:(GameScene*)scene;
- (void)addGameObject:(GameObject*)obj;
- (void)updateAllGameObject:(NSTimeInterval)dt;
- (void)didEvaluateActions;
- (void)didSimulatePhysics;
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
