#import "SceneMain.h"
#import "ScenePause.h"

@implementation SceneMain
- (id)init {
    if (self = [super init]) {
        Player* player = [[Player alloc] init];
        [_objectManager addGameObject:player];
        Enemy* enemy = [[Enemy alloc] init];
        [_objectManager addGameObject:enemy];
        NSString* path = [[NSBundle mainBundle] pathForResource:@"stage" ofType:@"tmxbin"];
        CGSize sz = self.size;
        _bg = [[GameBGNode alloc] initWithTMXFile:path size:sz];
        [self addChild:_bg];
        _bg.nodeCenter = CGPointMake(sz.width / 2.0f, sz.height / 2.0f);
        _bg.targetPosition = CGPointMake(sz.width / 2.0f+ 8, 0);
        _bg.delegate = self;
        [_bg updateNodes];
    }
    return self;
}
- (void)beforeObjectUpdate {
    CGPoint pt = _bg.targetPosition;
    pt.y += 0.5f;
    _bg.targetPosition = pt;
    [_bg updateNodes];
    // ApplicationがActiveじゃなくなったらポーズ画面にしておく
    GameView* gameview = _objectManager.scene.gameView;
    if (!gameview.isActive && gameview.stackCount == 0) {
        [gameview pushScene:[[ScenePause alloc] init] transition:[SKTransition doorsCloseHorizontalWithDuration:0.5f]];
    }
}
- (void)activateTile:(TMXTile*)tile {
    tile->work &= ~TMXTileOptionsNeedsToCallDelegate;
    tile->id = 32;
}
@end

@implementation PlayerShot
//
- (id)initWithPos:(CGPoint)pos dir:(f32)dir speed:(f32)speed {
    if (self = [super init]) {
        self.updateFunction = @selector(updateInit:);
        SKTexture* base = [SKTexture textureWithImageNamed:@"main"];
        SKTexture* tex = [SKTexture textureWithRect:[GameUtil calcWithUV:CGRectMake(24, 0, 7, 7) inTexture:base] inTexture:base];
        base.filteringMode = SKTextureFilteringNearest;
        //tex.filteringMode = SKTextureFilteringNearest;
        _sprite = [SKSpriteNode spriteNodeWithTexture:tex];
        _sprite.userData = [@{@"GameObject" : self} mutableCopy];
        //sprite.size = CGSizeMake(160, 160);
        _sprite.position = pos;
        //SKAction *action = [SKAction rotateByAngle:M_PI duration:31];
        //[sprite runAction:[SKAction repeatActionForever:action]];
        //tex.textureRect = CGRectMake(0, 0, 0.5f, 0.5f);
        _position = pos;
        _rotation = dir;
        _speed = speed;
        _sprite.physicsBody = [SKPhysicsBody bodyWithEdgeFromPoint:CGPointMake(-4, 0) toPoint:CGPointMake(+4, 0)];
        //_sprite.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:8.0f];
        //_sprite.physicsBody.dynamic = NO;
        _sprite.physicsBody.affectedByGravity = NO;
        _sprite.physicsBody.mass = 0;
        _sprite.physicsBody.collisionBitMask = 0xffffffff;
        _sprite.physicsBody.categoryBitMask = 0xffffffff;
        _sprite.physicsBody.contactTestBitMask = 0xffffffff;
    }
    return self;
}
//
- (void)updateInit:(GameObjectManager*)manager {
    [manager.scene.camera addChild:_sprite];
    self.updateFunction = @selector(updateNormal:);
    [self applyPosture:_sprite];
}
//
- (void)updateNormal:(GameObjectManager*)manager {
    if (![self isVisible:_sprite]) {
        [self removeReservation];
        return;
    }
    f32 speed = _speed * [GameTimer shared].deltaTime;
    _position.x += cosf(_rotation) * speed;
    _position.y += sinf(_rotation) * speed;
    [self applyPosture:_sprite];
}
//
- (void)willRemove {
    [_sprite removeFromParent];
}
//
- (void)didBeginContact:(SKPhysicsContact*)contact with:(GameObject*)other {
    [self removeReservation];
    PlayerShotEffect* eff = [[PlayerShotEffect alloc] initWithPos:contact.contactPoint dir:_rotation];
    [_manager addGameObject:eff];
}




@end

static Player* player = nil;
@implementation PlayerShotEffect
//
- (id)initWithPos:(CGPoint)pos dir:(f32)dir {
    if (self = [super init]) {
        self.updateFunction = @selector(updateInit:);
#if 0
        _emitter = [GameScene createEmitterNode:@"reflect"];
        _emitter.zPosition = +100;
        _emitter.position = pos;
        [_emitter resetSimulation];
        //NS_LOG(@"%d", _emitter.numParticlesToEmit);
#else
        _emitter = [player.revolver hireInstance];
        if (_emitter.parent)
            [_emitter removeFromParent];
        _emitter.zPosition = +100;
        _emitter.position = pos;
        [_emitter resetSimulation];
        //NS_LOG(@"%d", _emitter.numParticlesToEmit);
#endif
    }
    return self;
}
//
- (void)updateInit:(GameObjectManager*)manager {
    _emitter.targetNode = _manager.scene;//.camera;
    //[manager.scene/*.camera*/ addChild:_emitter];
    [manager.scene/*.camera*/ insertChild:_emitter atIndex:0];
    self.updateFunction = @selector(updateNormal:);
}
//
- (void)updateNormal:(GameObjectManager*)manager {
    if (_emitter.numParticlesToEmit == 0) {
        [self removeReservation];
        return;
    }
}
//
- (void)willRemove {
    //[_emitter removeFromParent];
}
@end

@implementation PlayerShotEffectRevolver
- (id)createInstance {
    return [GameScene createEmitterNode:@"reflect"];
}
@end

@implementation Player
//
- (id)init {
    if (self = [super init]) {
        self.updateFunction = @selector(updateInit:);
#if 0
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
#else
        SKTexture* base = [SKTexture textureWithImageNamed:@"main"];
        SKTexture* tex = [SKTexture textureWithRect:[GameUtil calcWithUV:CGRectMake(0, 0, 24, 24) inTexture:base] inTexture:base];
#endif
        _sprite = [SKSpriteNode spriteNodeWithTexture:tex];
        //sprite.size = CGSizeMake(160, 160);
        _sprite.position = CGPointMake(80, 120);
        _sprite.zPosition = 10;



        _revolver = [[PlayerShotEffectRevolver alloc] initWithNumOfStock:8];
        player = self;
    }
    return self;
}
//
- (void)resetAsNewbie {
    [super resetAsNewbie];
}
//
- (void)updateInit:(GameObjectManager*)manager {
    [manager.scene.camera addChild:_sprite];

#if 0
    SKEmitterNode* emi = [GameScene createEmitterNode:@"jet"];
    emi.zPosition = -100;
    emi.position = CGPointMake(0, -10);
    emi.targetNode = manager.scene;
    [_sprite addChild:emi];
#endif
    self.updateFunction = @selector(updateNormal:);
}
//
- (void)updateNormal:(GameObjectManager*)manager {
    CGPoint stick = [GameHID shared].leftStick;
    CGPoint pos = _sprite.position;
    f32 speed = 200.0f * [GameTimer shared].deltaTime;
    pos.x += stick.x * speed;
    pos.y += stick.y * speed;
    _sprite.position = pos;
    _reload -= [GameTimer shared].deltaTime;
    if ([GameHID shared].isTouch && _reload <= 0.0f) {
        [self shootWithOffset:CGPointMake(-4, +8) dir:GAME_D2R(90) speed:500 manager:manager];
        [self shootWithOffset:CGPointMake(+4, +8) dir:GAME_D2R(90) speed:500 manager:manager];
        //[self shoot:GAME_D2R(90-30) speed:300 manager:manager];
        //[self shoot:GAME_D2R(90+30) speed:300 manager:manager];
        //[self shoot:GAME_D2R(270-30) speed:300 manager:manager];
        //[self shoot:GAME_D2R(270+30) speed:300 manager:manager];
        _reload = 0.07f;
    }
}
//
- (void)shootWithOffset:(CGPoint)ofs dir:(f32)dir speed:(f32)speed manager:(GameObjectManager*)manager {
    ofs.x += _sprite.position.x;
    ofs.y += _sprite.position.y;
    PlayerShot* shot = [[PlayerShot alloc] initWithPos:ofs dir:dir speed:speed];
    [manager addGameObject:shot];
}



@end

@implementation Enemy
//
- (id)init {
    if (self = [super init]) {
        self.updateFunction = @selector(updateInit:);
        SKTexture* base = [SKTexture textureWithImageNamed:@"main"];
        SKTexture* tex = [SKTexture textureWithRect:[GameUtil calcWithUV:CGRectMake(32, 8, 16, 16) inTexture:base] inTexture:base];
        _sprite = [SKSpriteNode spriteNodeWithTexture:tex];
        _sprite.userData = [@{@"GameObject" : self} mutableCopy];
        //sprite.size = CGSizeMake(160, 160);
        _sprite.position = CGPointMake(80, 220);
        _sprite.zPosition = 10;
        _sprite.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:8.0f];
        _sprite.physicsBody.affectedByGravity = NO;
        //_sprite.physicsBody.dynamic = NO;
        _sprite.physicsBody.mass = 0;
        _sprite.physicsBody.restitution = 0;
        _sprite.physicsBody.collisionBitMask = 0xffffffff;
        _sprite.physicsBody.categoryBitMask = 0xffffffff;
        _sprite.physicsBody.contactTestBitMask = 0xffffffff;
        //
        _sprite.color = [SKColor blueColor];
    }
    return self;
}
//
- (void)updateInit:(GameObjectManager*)manager {
    [manager.scene.camera addChild:_sprite];

#if 0
    SKEmitterNode* emi = [GameScene createEmitterNode:@"jet"];
    emi.zPosition = -100;
    emi.position = CGPointMake(0, -10);
    emi.targetNode = manager.scene;
    [_sprite addChild:emi];
#endif
    self.updateFunction = @selector(updateNormal:);
}
//
- (void)updateNormal:(GameObjectManager*)manager {
    _sprite.position = CGPointMake(80, 220);
    _sprite.colorBlendFactor = _damage;
    _damage *= 0.8f;
}
//
- (void)didBeginContact:(SKPhysicsContact*)contact with:(GameObject*)other {
    _damage = 1.0f;
}
//
- (void)didSimulatePhysics {
    _sprite.position = CGPointMake(80, 220);
}


@end
