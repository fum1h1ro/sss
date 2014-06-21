#import "EnemyGenerator.h"

@implementation EnemyGenerator
//
- (instancetype)initWithManager:(GameObjectManager*)manager {
    if (self = [super init]) {
        _idx = -1;
        _manager = manager;
    }
    return self;
}
//
- (void)update {
    if (!_table) return;
    const f32 dt = [GameTimer shared].deltaTime;
    if (!_current) {
        [self next];
    }
    _wait = fmax(_wait - dt, 0.0f);
    if (_wait == 0.0f) {
        if ([self evaluate:_current]) {
            [self next];
        }
    }
}
//
- (void)next {
    _idx += 1;
    if (_idx >= [_table count]) {
        _idx = 0;
    }
    _current = _table[_idx];
    _wait = [_current[0] floatValue];
}
//
- (BOOL)evaluate:(NSArray*)elem {
    NSString* name = elem[1];
    if ([name compare:@"nop"] == NSOrderedSame) {
        return YES;
    } else
    if ([name compare:@"wait"] == NSOrderedSame) {
        // 敵が全滅するまで待つ
        return [_manager populationWithType:kOBJTYPE_ENEMY_IN_AIR] <= 0;
    } else {
        f32 x = [elem[2] floatValue];
        f32 y = [elem[3] floatValue];
        Class cls = NSClassFromString(name);
        EnemyInAir* enemy = [[cls alloc] initWithPos:CGPointMake(x, y)];
        [_manager addGameObject:enemy];
        return YES;
    }
}

@end
