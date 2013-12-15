#import "SceneMain.h"
#import "ScenePause.h"
#import "const.h"
#import "Enemy.h"
#import "AppDelegate.h"

@implementation EffectRevolver
//
- (id)initWithNumOfStock:(u32)num effectName:(NSString*)effname {
    if (self = [super initWithNumOfStock:num]) {
        _effname = effname;
        [self createInstances];
    }
    return self;
}
//
- (id)createInstance {
    return [GameScene createEmitterNode:_effname];
}
@end

@implementation SceneMain
- (id)init {
    if (self = [super init]) {
        // 背景処理
        NSString* path = [[NSBundle mainBundle] pathForResource:@"stage" ofType:@"tmxbin"];
        CGSize sz = self.size;
        _background = [[Background alloc] initWithTMXFile:path size:sz];
        [_objectManager addGameObject:_background];
        _background.bgNode.delegate = self;
        //
        Player* p = [[Player alloc] init];
        self.player = [self createPlayer];
        EnemyInAir* enemy = [[EnemyInAir alloc] initWithPos:CGPointMake(0, 100)];
        [_objectManager addGameObject:enemy];
        // 使い回し用エフェクト
        _shotReflectEffect = [[EffectRevolver alloc] initWithNumOfStock:8 effectName:@"reflect"];
        _smallBombEffect = [[EffectRevolver alloc] initWithNumOfStock:8 effectName:@"small_bomb"];


        _groundenemytable = [AppDelegate readJSON:@"groundenemytable"];
        NS_LOG(@"tbl:%@", _groundenemytable);



        _score = [SKLabelNode labelNodeWithFontNamed:@"DIN Condensed"];
        _score.zPosition = 100;
        _score.fontSize = 16;
        _score.text = [NSString localizedStringWithFormat:@"SCORE: %05ld", 0];
        [self addChild:_score];
    }
    return self;
}
//
- (void)beforeObjectUpdate {
    // ApplicationがActiveじゃなくなったらポーズ画面にしておく
    GameView* gameview = _objectManager.scene.gameView;
    if (self.shouldPause) {
        [gameview pushScene:[[ScenePause alloc] init] transition:[SKTransition doorsCloseHorizontalWithDuration:0.5f]];
        self.shouldPause = NO;
    }
    _score.text = [NSString localizedStringWithFormat:@"SCORE: %05ld", [Profile shared].score];
}
//
- (void)afterObjectUpdate {
    if (self.player) {
        CGPoint pt = _camera.target;
        pt.x = _player.position.x * 0.5f;
        CGSize mapsz = _background.bgNode.mapSize;
        CGSize tilesz = _background.bgNode.tileSize;
        CGSize screensz = _background.bgNode.screenSize;
        CGFloat availablesz = (mapsz.width * tilesz.width - screensz.width) * 0.5f;
        pt.x = fmin(fmax(-availablesz, pt.x), availablesz);
        _camera.target = pt;
        _background.offsetX = pt.x;
    } else {
        _player = [self createPlayer];
    }
}
//
- (void)gameBGNode:(GameBGNode*)node activateTile:(TMXTile*)tile position:(CGPoint)pos {
    // 敵のデータはgroundenemytable.jsonに記述されている
    NSDictionary* element = _groundenemytable[[NSString stringWithFormat:@"%d", tile->type]];
    if (element != nil) {
        NSDictionary* velement = element;
        NSNumber* link = element[@"link"];
        s32 offset = 0;
        if (link) {
            velement = _groundenemytable[[NSString stringWithFormat:@"%d", [link intValue]]];
            offset = tile->type - [link intValue];
        }
        s32 size = [velement[@"size"] intValue];
        SKTexture* tex;
        switch (size) {
            case 1:
                tex = [_background.bgNode getPattern:tile->id];
                tile->id = (tile->id / _background.bgNode.patternColumn) * _background.bgNode.patternColumn;
                break;
            case 2:
                {
                    tex = [_background.bgNode getPattern:tile->id withSize:CGSizeMake(2, 2)];
                    tile->id = (tile->id / _background.bgNode.patternColumn) * _background.bgNode.patternColumn;
                    u16 shift[] = { 0, 1, 0, 1 };
                    tile->id += shift[offset];
                }
                break;
        }
        // 自タイルの位置に地上敵を生成する
        EnemyOnGround* enemy;
        // クラス名が指定されているかも知れない
        if ([velement[@"klass"] length] > 0) {
            Class cls = NSClassFromString(velement[@"klass"]);
            enemy = [[cls alloc] initWithPos:pos texture:tex];
        } else {
            enemy = [[EnemyOnGround alloc] initWithPos:pos texture:tex];
        }
        enemy.preferNodeToAdd = _background.originNode;
        enemy.hp = [element[@"hp"] intValue];
        enemy.score = [element[@"score"] intValue];
        [_objectManager addGameObject:enemy];
    }
    // 再度呼ばれないようフラグを下げておく
    tile->attr &= ~TMXTileOptionsNeedsToCallDelegate;
}
//
- (Player*)createPlayer {
    Player* player = [[Player alloc] init];
    CGSize mapsz = _background.bgNode.mapSize;
    CGSize tilesz = _background.bgNode.tileSize;
    CGSize screensz = _background.bgNode.screenSize;
    CGSize availablesz = CGSizeMake(mapsz.width * tilesz.width, screensz.height);
    player.availableArea = CGRectMake(-availablesz.width * 0.5f, -availablesz.height * 0.5f, availablesz.width, availablesz.height);
    [_objectManager addGameObject:player];
    return player;
}
@end

@implementation PlayerShot
//
- (id)initWithPos:(CGPoint)pos dir:(f32)dir speed:(f32)speed {
    if (self = [super init]) {
        // GameObjectの処理関数をupdateInit:に指定する
        self.updateFunction = @selector(updateNormal:);
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
- (void)updateNormal:(GameObjectManager*)manager {
    if (self.lifeTime == 0.0f) {
        [manager.scene.camera addChild:_sprite];
    }
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
    _sprite.userData = nil;
    [_sprite removeFromParent];
}
//
- (void)didBeginContact:(SKPhysicsContact*)contact with:(GameObject*)other {
    [self removeReservation];
    PlayerShotEffect* eff = [[PlayerShotEffect alloc] initWithPos:contact.contactPoint dir:_rotation];
    [_manager addGameObject:eff];
}




@end

@implementation PlayerShotEffect
//
- (id)initWithPos:(CGPoint)pos dir:(f32)dir {
    if (self = [super init]) {
        self.updateFunction = @selector(updateInit:);
        _position = pos;
        _rotation = dir;
    }
    return self;
}
//
- (void)updateInit:(GameObjectManager*)manager {
    SceneMain* scene = (SceneMain*)manager.scene;
    SKEmitterNode* emitter = [scene.shotReflectEffect hireInstance];
    emitter.zPosition = +100;
    emitter.position = _position;
    if (emitter.parent)
        [emitter removeFromParent];
    emitter.targetNode = _manager.scene;//.camera;
    [manager.scene/*.camera*/ addChild:emitter];
    [emitter resetSimulation]; // resetSimulationは、ノードを追加してから呼ばないとダメらしい
    self.updateFunction = @selector(updateNormal:);
}
//
- (void)updateNormal:(GameObjectManager*)manager {
    if (self.lifeTime > 0.2f) {
        [self removeReservation];
    }
}
//
- (void)willRemove {
    //[_emitter removeFromParent];
}
@end


@implementation Player
//
- (id)init {
    if (self = [super init]) {
        self.updateFunction = @selector(updateEnter:);
        _position = CGPointMake(0, 0);
        _power = kPLAYER_POWER_2;
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
        _sprite.zPosition = (CGFloat)kOBJ_ZPOSITION_PLAYER;
        _sprite.color = [SKColor clearColor];
        _sprite.userData = [@{@"GameObject" : self} mutableCopy];
        // 当たり判定用の剛体を作る
        _sprite.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:8];
        // 物理法則は無視して当たり判定のみを使うので、重力の影響をなしにする
        _sprite.physicsBody.affectedByGravity = NO;
        //_sprite.physicsBody.dynamic = YES; // 線タイプの剛体は、デフォルトでstatic
        //_sprite.physicsBody.mass = 0;
        // SKPhysicsBodyの当たる当たらないを設定する
        _sprite.physicsBody.categoryBitMask = kHITBIT_PLAYER;
        _sprite.physicsBody.collisionBitMask = 0;//kHITBIT_ENEMY_ON_GROUND|kHITBIT_ENEMY_IN_AIR; // この剛体は地上の敵と空中の敵に当たる
        _sprite.physicsBody.contactTestBitMask = 0;//kHITBIT_ENEMY_ON_GROUND|kHITBIT_ENEMY_IN_AIR; // この剛体は地上の敵と空中の敵に当たった時、delegateを呼ぶ
    }
    return self;
}
//
- (void)resetAsNewbie {
    [super resetAsNewbie];
}
//
- (void)willRemove {
    _sprite.userData = nil;
    [_sprite removeFromParent];
}
//
- (void)updateEnter:(GameObjectManager*)manager {
    if (self.lifeTime == 0.0f) {
        [manager.scene.camera addChild:_sprite];
        _infinity = 4.0f;
        _position = CGPointMake(0, -100);
    }
#if 0
    SKEmitterNode* emi = [GameScene createEmitterNode:@"jet"];
    emi.zPosition = -100;
    emi.position = CGPointMake(0, -10);
    emi.targetNode = manager.scene;
    [_sprite addChild:emi];
#endif
    self.updateFunction = @selector(updateNormal:);
    [self updateCommon];
}
//
- (void)updateNormal:(GameObjectManager*)manager {
    [self controlMoving];
    _reload -= [GameTimer shared].deltaTime;
    if ([GameHID shared].isTouch && _reload <= 0.0f) {
        [self shoot:manager];
        _reload = 0.15f;
    }
    [self updateCommon];
}
//
- (void)updateBomb:(GameObjectManager*)manager {
    SceneMain* scene = (SceneMain*)manager.scene;
    SKEmitterNode* emitter = [GameScene createEmitterNode:@"tiuntiun"];
    emitter.zPosition = +100;
    emitter.position = _position;
    emitter.targetNode = manager.scene.camera;
    [manager.scene.camera addChild:emitter];
    [self removeReservation];
}
//
- (void)updateCommon {
    // 無敵時間を減らしておく
    _infinity = fmax(_infinity - [GameTimer shared].deltaTime, 0.0f);
    // 無敵時間中は、自機を点滅させる。今回は、clearColorとのブレンドをいじる
    if (_infinity > 0.0f) {
        f32 interval = _infinity * (GAME_PI * 2.0f * 2.0f);
        f32 v = sinf(interval);
        if (v < 0.0f) v *= -1.0f;
        _sprite.colorBlendFactor = v;
    } else {
        _sprite.colorBlendFactor = 0.0f;
    }
    // パワーが負になると撃墜されたことになる
    if (_power < 0) {
        self.updateFunction = @selector(updateBomb:);
    }
}
//
- (void)controlMoving {
    CGPoint stick = [GameHID shared].leftStick;
    f32 speed = 400.0f * [GameTimer shared].deltaTime;
    _position.x += stick.x * speed;
    _position.y += stick.y * speed;
    _position.x = fmin(fmax(_position.x, CGRectGetMinX(_availableArea)), CGRectGetMaxX(_availableArea));
    _position.y = fmin(fmax(_position.y, CGRectGetMinY(_availableArea)), CGRectGetMaxY(_availableArea));
    [self applyPosture:_sprite];
}
//
- (void)shoot:(GameObjectManager*)manager {
    switch (_power) {
        case kPLAYER_POWER_0:
            [self shootWithOffset:CGPointMake(-4, +8) dir:GAME_D2R(90) speed:600 manager:manager];
            [self shootWithOffset:CGPointMake(+4, +8) dir:GAME_D2R(90) speed:600 manager:manager];
            break;
        case kPLAYER_POWER_1:
            [self shootWithOffset:CGPointMake(-4, +8) dir:GAME_D2R(90) speed:600 manager:manager];
            [self shootWithOffset:CGPointMake(+4, +8) dir:GAME_D2R(90) speed:600 manager:manager];
            [self shootWithOffset:CGPointMake(+0, -8) dir:GAME_D2R(270) speed:600 manager:manager];
            break;
        case kPLAYER_POWER_2:
            [self shootWithOffset:CGPointMake(-4, +8) dir:GAME_D2R(90) speed:600 manager:manager];
            [self shootWithOffset:CGPointMake(+4, +8) dir:GAME_D2R(90) speed:600 manager:manager];
            [self shootWithOffset:CGPointMake(-6, +0) dir:GAME_D2R(90+30) speed:600 manager:manager];
            [self shootWithOffset:CGPointMake(+6, +0) dir:GAME_D2R(90-30) speed:600 manager:manager];
            [self shootWithOffset:CGPointMake(+0, -8) dir:GAME_D2R(270) speed:600 manager:manager];
            break;
        case kPLAYER_POWER_3:
            [self shootWithOffset:CGPointMake(-4, +8) dir:GAME_D2R(90) speed:600 manager:manager];
            [self shootWithOffset:CGPointMake(+4, +8) dir:GAME_D2R(90) speed:600 manager:manager];
            [self shootWithOffset:CGPointMake(-6, +0) dir:GAME_D2R(90+30) speed:600 manager:manager];
            [self shootWithOffset:CGPointMake(+6, +0) dir:GAME_D2R(90-30) speed:600 manager:manager];
            [self shootWithOffset:CGPointMake(-4, -8) dir:GAME_D2R(270-30) speed:600 manager:manager];
            [self shootWithOffset:CGPointMake(+4, -8) dir:GAME_D2R(270+30) speed:600 manager:manager];
            break;
    }
}
//
- (void)shootWithOffset:(CGPoint)ofs dir:(f32)dir speed:(f32)speed manager:(GameObjectManager*)manager {
    ofs.x += _sprite.position.x;
    ofs.y += _sprite.position.y;
    PlayerShot* shot = [[PlayerShot alloc] initWithPos:ofs dir:dir speed:speed];
    [manager addGameObject:shot];
}
// ダメージを与える（無敵中ならNOを返す
- (BOOL)damage {
    if (_infinity > 0.0f) {
        return NO;
    } else {
        // 残念ながら無敵でなかったので、パワーダウンして少しの間無敵にしておく
        _infinity = 2.0f;
        _power -= 1;
        return YES;
    }
}


@end

