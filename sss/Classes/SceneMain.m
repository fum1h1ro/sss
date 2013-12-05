#import "SceneMain.h"
#import "ScenePause.h"
#import "const.h"
#import "Enemy.h"

@implementation SceneMain
- (id)init {
    if (self = [super init]) {
        Player* player = [[Player alloc] init];
        [_objectManager addGameObject:player];
        Enemy* enemy = [[Enemy alloc] init];
        [_objectManager addGameObject:enemy];
        // 背景処理
        NSString* path = [[NSBundle mainBundle] pathForResource:@"stage" ofType:@"tmxbin"];
        CGSize sz = self.size;
        _background = [[Background alloc] initWithTMXFile:path size:sz];
        [_objectManager addGameObject:_background];
        _background.bgNode.delegate = self;
    }
    return self;
}
- (void)beforeObjectUpdate {
    // ApplicationがActiveじゃなくなったらポーズ画面にしておく
    GameView* gameview = _objectManager.scene.gameView;
    if (!gameview.isActive && gameview.stackCount == 0) {
        [gameview pushScene:[[ScenePause alloc] init] transition:[SKTransition doorsCloseHorizontalWithDuration:0.5f]];
    }
}
//
- (void)activateTile:(TMXTile*)tile position:(CGPoint)pos {
    // 自タイルの位置に地上敵を生成する
    EnemyOnGround* enemy = [[EnemyOnGround alloc] initWithPos:pos texture:[_background.bgNode getPattern:tile->id]];
    enemy.preferNodeToAdd = _background.originNode;
    [_objectManager addGameObject:enemy];
    // 再度呼ばれないようフラグを下げておく
    tile->work &= ~TMXTileOptionsNeedsToCallDelegate;
    tile->id = 32;
}
@end

@implementation PlayerShot
//
- (id)initWithPos:(CGPoint)pos dir:(f32)dir speed:(f32)speed {
    if (self = [super init]) {
        // GameObjectの処理関数をupdateInit:に指定する
        self.updateFunction = @selector(updateInit:);
        _position = pos;
        _rotation = dir;
        _speed = speed;
        // SKSpriteNodeを作る
        //   テクスチャを取得する
        SKTexture* base = [SKTexture textureWithImageNamed:@"main"];
        //   そのテクスチャの一部を利用する
        SKTexture* tex = [SKTexture textureWithRect:[GameUtil calcWithUV:CGRectMake(24, 0, 8, 8) inTexture:base] inTexture:base];
        base.filteringMode = SKTextureFilteringNearest;
        //   テクスチャからSKSpriteNodeを作る
        _sprite = [SKSpriteNode spriteNodeWithTexture:tex];
        _sprite.userData = [@{@"GameObject" : self} mutableCopy];
        _sprite.zPosition = (CGFloat)kOBJ_ZPOSITION_PLAYER_SHOT;
        [self applyPosture:_sprite];
        // 当たり判定用の剛体を作る
        //_sprite.physicsBody = [SKPhysicsBody bodyWithEdgeFromPoint:CGPointMake(-4, 0) toPoint:CGPointMake(+4, 0)];
        _sprite.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:4];
        // 物理法則は無視して当たり判定のみを使うので、重力の影響をなしにする
        _sprite.physicsBody.affectedByGravity = NO;
        _sprite.physicsBody.dynamic = YES; // 線タイプの剛体は、デフォルトでstatic
        //_sprite.physicsBody.mass = 0;
        // SKPhysicsBodyの当たる当たらないを設定する
        _sprite.physicsBody.categoryBitMask = kHITBIT_PLAYER_SHOT; // この剛体は自機の弾である
        _sprite.physicsBody.collisionBitMask = kHITBIT_ENEMY_ON_GROUND|kHITBIT_ENEMY_IN_AIR; // この剛体は地上の敵と空中の敵に当たる
        _sprite.physicsBody.contactTestBitMask = kHITBIT_ENEMY_ON_GROUND|kHITBIT_ENEMY_IN_AIR; // この剛体は地上の敵と空中の敵に当たった時、delegateを呼ぶ
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
        _emitter.zPosition = +100;
        _emitter.position = pos;
        //NS_LOG(@"%d", _emitter.numParticlesToEmit);
#endif
    }
    return self;
}
//
- (void)updateInit:(GameObjectManager*)manager {
    if (_emitter.parent)
        [_emitter removeFromParent];
    _emitter.targetNode = _manager.scene;//.camera;
    [manager.scene/*.camera*/ addChild:_emitter];
    [_emitter resetSimulation]; // resetSimulationは、ノードを追加してから呼ばないとダメらしい
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
        _sprite.zPosition = (CGFloat)kOBJ_ZPOSITION_PLAYER;



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
    f32 speed = 400.0f * [GameTimer shared].deltaTime;
    pos.x += stick.x * speed;
    pos.y += stick.y * speed;
    _sprite.position = pos;
    _reload -= [GameTimer shared].deltaTime;
    if ([GameHID shared].isTouch && _reload <= 0.0f) {
        [self shootWithOffset:CGPointMake(-4, +8) dir:GAME_D2R(90) speed:600 manager:manager];
        [self shootWithOffset:CGPointMake(+4, +8) dir:GAME_D2R(90) speed:600 manager:manager];
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

