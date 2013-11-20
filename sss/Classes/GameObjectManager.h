#import "GameCommon.h"
@class GameObjectManager;
@class GameScene;

#define kGAME_OBJECT_DEFAULT_PRIORITY 1000
@interface GameObject : NSObject {
    SEL _updateFunction;
}
@property (strong, nonatomic) GameObjectManager* manager;
@property (assign, nonatomic) s32 priority;
@property (assign, readonly, nonatomic) BOOL isKill;
- (void)update:(NSTimeInterval)dt;
- (void)setKill;
@end

@interface GameObjectManager : NSObject {
    BOOL _needsSort;
}
@property (strong, nonatomic) GameScene* scene;
@property (strong, nonatomic) NSMutableArray* array;
- (id)initWithScene:(GameScene*)scene;
- (void)addGameObject:(GameObject*)obj;
- (void)updateAllGameObject:(NSTimeInterval)dt;
@end










@interface PlayerShot : GameObject {
    SKSpriteNode* _sprite;
}
@end

@interface Player : GameObject {
    SKSpriteNode* _sprite;
}
@end
