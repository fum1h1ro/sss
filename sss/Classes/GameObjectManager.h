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










