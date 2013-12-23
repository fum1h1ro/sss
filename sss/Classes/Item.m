#import "Item.h"

//
@implementation Item
- (instancetype)initWithPos:(CGPoint)pos {
    if (self = [super init]) {
        _position = pos;
        _center = pos.x;
        _time = 0.0f;
    }
    return self;
}
//
- (void)updateCommon {
    f32 dt = [GameTimer shared].deltaTime;
    _position.x = _center + sin(_time) * 64.0f;
    _position.y -= 36.0f * dt;
    _time += GAME_2PI * (1.0f/2.0f) * dt;
    SceneMain* scene = (SceneMain*)_manager.scene;
    if (!_visible) {
        if ([scene includeRectHorizontally:CGRectMake(_position.x, _position.y, 16, 16)]) {
            _visible = YES;
        }
    } else
    if (![scene includeRectHorizontally:CGRectMake(_position.x, _position.y, 16, 16)]) {
        [self removeReservation];
    }
}

@end
//
@implementation ItemPowerUp
- (instancetype)initWithPos:(CGPoint)pos {
    if (self = [super initWithPos:pos]) {
        _sprite = [self makeSpriteNode:@"main" rect:CGRectMake(16, 0, 2, 2)];
        _sprite.zPosition = (CGFloat)kOBJ_ZPOSITION_ITEM;
        _sprite.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:8.0f];
        _sprite.physicsBody.affectedByGravity = NO;
        _sprite.physicsBody.dynamic = NO;
        _sprite.physicsBody.mass = 0;
        _sprite.physicsBody.restitution = 0;
        _sprite.physicsBody.categoryBitMask = kHITBIT_ITEM;
        _sprite.physicsBody.collisionBitMask = kHITBIT_PLAYER;
        _sprite.physicsBody.contactTestBitMask = kHITBIT_PLAYER;
        [self applyPosture:_sprite];
        self.updateFunction = @selector(updateNormal:);
    }
    return self;
}
//
- (void)updateNormal:(GameObjectManager*)manager {
    if (self.lifeTime == 0.0f && _sprite.parent == nil) {
        [_manager.scene.camera addChild:_sprite];
    }
    [self updateCommon];
    [self applyPosture:_sprite];
}
//
- (void)didBeginContact:(SKPhysicsContact*)contact with:(GameObject*)other {
    [[Profile shared] addScore:1000];
    [(Player*)other applyPowerUp]; // otherはPlayerなはず
    [self removeReservation];
}

@end
//
@implementation ItemBonus
- (instancetype)initWithPos:(CGPoint)pos {
    if (self = [super initWithPos:pos]) {
        _sprite = [self makeSpriteNode:@"main" rect:CGRectMake(14, 0, 2, 2)];
        _sprite.zPosition = (CGFloat)kOBJ_ZPOSITION_ITEM;
        _sprite.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:8.0f];
        _sprite.physicsBody.affectedByGravity = NO;
        _sprite.physicsBody.dynamic = NO;
        _sprite.physicsBody.mass = 0;
        _sprite.physicsBody.restitution = 0;
        _sprite.physicsBody.categoryBitMask = kHITBIT_ITEM;
        _sprite.physicsBody.collisionBitMask = kHITBIT_PLAYER;
        _sprite.physicsBody.contactTestBitMask = kHITBIT_PLAYER;
        [self applyPosture:_sprite];
        self.updateFunction = @selector(updateNormal:);
    }
    return self;
}
//
- (void)updateNormal:(GameObjectManager*)manager {
    if (self.lifeTime == 0.0f && _sprite.parent == nil) {
        [_manager.scene.camera addChild:_sprite];
    }
    [self updateCommon];
    [self applyPosture:_sprite];
}
//
- (void)didBeginContact:(SKPhysicsContact*)contact with:(GameObject*)other {
    [[Profile shared] addScore:1000];
    [self removeReservation];
}

@end
