#import "GameView.h"
#import "GameScene.h"
#import "GameObjectManager.h"
#import "GameHID.h"
#import "GameUtil.h"

@implementation GameObject
//
- (id)init {
    if (self = [super init]) {
        _priority = kGAME_OBJECT_DEFAULT_PRIORITY;
    }
    return self;
}
//
- (void)update:(NSTimeInterval)dt {
    if (_updateFunction)
        [self performSelector:_updateFunction];
}
//
- (void)setKill {
    _isKill = YES;
}
@end

@implementation GameObjectManager
//
- (id)initWithScene:(GameScene*)scene {
    if (self = [super init]) {
        self.scene = scene;
        self.array = [NSMutableArray arrayWithCapacity:128];
    }
    return self;
}
// ゲームオブジェクトを追加する
- (void)addGameObject:(GameObject*)obj {
    obj.manager = self;
    [self.array addObject:obj];
    NS_LOG(@"%d", [self.array count]);
    _needsSort = YES;
}
// 
- (void)updateAllGameObject:(NSTimeInterval)dt {
    if (_needsSort) {
        // @todo ソートする
        _needsSort = NO;
    }
    s32 sz = [_array count];
    for (s32 i = 0; i < sz;) {
        GameObject* obj = _array[i];
        [obj update:dt];
        if (obj.isKill) {
            [_array removeObjectAtIndex:i];
            --sz;
        } else {
            ++i;
        }
    }
}

@end





@implementation PlayerShot
//
- (id)init {
    if (self = [super init]) {
        _updateFunction = @selector(updateInit:);
    }
    return self;
}





@end




@implementation Player
//
- (id)init {
    if (self = [super init]) {
        _updateFunction = @selector(updateInit:);
    }
    return self;
}
//
- (void)updateInit:(NSTimeInterval)dt {
    SKTextureAtlas* atlas = [SKTextureAtlas atlasNamed:@"Test"];
    SKTexture* base = [atlas textureNamed:@"sss"];
    CGRect baserc = base.textureRect;
    [GameUtil dumpCGRect:baserc];
    //SKTexture* base = [SKTexture textureWithImageNamed:@"sss"];
    CGRect shiprc = [GameUtil recalcCGRect:CGRectMake(0, 0, 0.5f, 0.5f) inRect:baserc];
    SKTexture* tex = [SKTexture textureWithRect:shiprc inTexture:base];
    //base.filteringMode = SKTextureFilteringNearest;
    //tex.filteringMode = SKTextureFilteringNearest;
    CGRect rc = [tex textureRect];
    [GameUtil dumpCGRect:rc];
    _sprite = [SKSpriteNode spriteNodeWithTexture:tex];
    //sprite.size = CGSizeMake(160, 160);
    _sprite.position = CGPointMake(160, 240);
    //SKAction *action = [SKAction rotateByAngle:M_PI duration:31];
    //[sprite runAction:[SKAction repeatActionForever:action]];
    //tex.textureRect = CGRectMake(0, 0, 0.5f, 0.5f);
    [self.manager.scene addChild:_sprite];

    SKEmitterNode* emi = [GameScene createEmitterNode:@"jet"];
    emi.zPosition = -100;
    emi.position = CGPointMake(0, -10);
    emi.targetNode = self.manager.scene;
    [_sprite addChild:emi];
    _updateFunction = @selector(updateNormal:);
}
//
- (void)updateNormal:(NSTimeInterval)dt {
    CGPoint stick = [GameHID shared].leftStick;
    CGPoint pos = _sprite.position;
    pos.x += stick.x * 3.5f;
    pos.y += stick.y * 3.5f;
    _sprite.position = pos;
}




@end
