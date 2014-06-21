#import "Game.h"
#import "Enemy.h"

// 敵生成器
@interface EnemyGenerator : NSObject {
    NSArray* _current;
    s32 _idx;
    f32 _wait;
    GameObjectManager* _manager;
}
@property (strong, nonatomic) NSArray* table;
- (instancetype)initWithManager:(GameObjectManager*)manager;
- (void)update;
@end
