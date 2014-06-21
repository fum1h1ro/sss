#import "Game.h"
#import "Background.h"
#import "EnemyGenerator.h"

@interface EffectRevolver : GameInstanceRevolver {
    NSString* _effname;
}
- (id)initWithNumOfStock:(u32)num effectName:(NSString*)effname;
@end

@class Player;
@class InformationDisplay;

@interface SceneMain : GameScene<GameBGNodeDelegate> {
    Background* _background;
    NSDictionary* _groundenemytable;
    NSArray* _enemytable;
    f32 _playTime;
    InformationDisplay* _informationDisplay;
    s32 _continuousBonusIndex;
    EnemyGenerator* _enemyGenerator;
}
@property (strong, readonly, nonatomic) EffectRevolver* shotReflectEffect;
@property (strong, readonly, nonatomic) EffectRevolver* smallBombEffect;
@property (strong, readonly, nonatomic) EffectRevolver* bombEffect;
@property (weak, nonatomic) Player* player;
@property (strong, nonatomic) InformationDisplay* informationDisplay;
@property (assign, nonatomic) f32 playTime;
@property (assign, readonly, nonatomic) CGRect availableRect;
- (void)addBonus:(s64)bonus;
- (void)addContinuousBonus:(NSArray*)bonustable;
- (BOOL)includeRect:(CGRect)rc;
- (BOOL)includeRectHorizontally:(CGRect)rc;
- (BOOL)includeRectVertically:(CGRect)rc;
@end


@interface PlayerShot : GameObject {
    f32 _speed;
}
- (id)initWithPos:(CGPoint)pos dir:(f32)dir speed:(f32)speed;
@end

@interface PlayerShotEffect : GameObject {
}
- (id)initWithPos:(CGPoint)pos dir:(f32)dir;
@end


@interface Player : GameObject {
    f32 _reload, _infinity;
    s32 _power;
    f32 _enterCount;
}
@property (assign, nonatomic) CGRect availableArea;
- (instancetype)initWithPos:(CGPoint)pos;
- (BOOL)damage;
- (void)applyPowerUp;
@end

@interface InformationDisplay : GameObject {
    SceneMain* _sceneMain;
    SKLabelNode* _score;
    SKLabelNode* _time;
    SKLabelNode* _bonus;
    s64 _dispScore;
}
- (instancetype)initWithSceneMain:(SceneMain*)scenemain;
- (void)displayBonus:(s64)bonus;
@end
