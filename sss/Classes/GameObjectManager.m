#import "GameView.h"
#import "GameScene.h"
#import "GameObject.h"
#import "GameObjectManager.h"
#import "GameHID.h"
#import "GameUtil.h"

// ゲームオブジェクトを管理するクラスです
// 基本的には、ゲームオブジェクトを配列として複数持ち、
// 毎フレーム全てのゲームオブジェクトに対して更新を行います
// 同時に、ゲームオブジェクトから自分を削除して欲しいという要求があれば、
// 削除します（Objective-Cの仕様上、ここで必ずしもデストラクタが呼ばれるわけではない）
@implementation GameObjectManager
//
- (id)initWithScene:(GameScene*)scene {
    if (self = [super init]) {
        self.scene = scene;
        self.active = [NSMutableArray arrayWithCapacity:1024];
        self.newbie = [NSMutableArray arrayWithCapacity:1024];
        self.remove = [NSMutableIndexSet indexSet];
    }
    return self;
}
// ゲームオブジェクトを追加する
// ここで追加されたゲームオブジェクトは、次のフレーム（updateAllGameObject:）から処理されるようになる
- (void)addGameObject:(GameObject*)obj {
    [_newbie addObject:obj];
    obj.manager = self;
    [obj resetAsNewbie]; // リセットされる
}
// 全てのゲームオブジェクトを更新する
- (void)updateAllGameObject:(NSTimeInterval)dt {
    // 新たに入ってくるものが居るなら、ここで追加する
    if ([_newbie count] > 0) {
        [_active addObjectsFromArray:_newbie];
        [_newbie removeAllObjects];
        // @todo ソートする
    }
    u32 idx = 0;
    for (GameObject* obj in _active) {
        [obj updateWithManager:self];
        // 削除要求が来ていたら、削除リストに追加しておく
        if (obj.isRemove) {
            [obj willRemove];
            obj.manager = nil;
            [_remove addIndex:idx];
        }
        ++idx;
    }
    // 削除予約されたものがあるなら
    if ([_remove count] > 0) {
        [_active removeObjectsAtIndexes:_remove];
        [_remove removeAllIndexes];
    }
}
// アクション計算後に呼ばれる（あまり必要でない気がする。アクション使わないので）
- (void)didEvaluateActions {
    for (GameObject* obj in _active) {
        if ([obj respondsToSelector:@selector(didEvaluateActions)])
            [obj performSelector:@selector(didEvaluateActions)];
    }
}
// 物理シミュ終了時に呼ばれる
- (void)didSimulatePhysics {
    for (GameObject* obj in _active) {
        if ([obj respondsToSelector:@selector(didSimulatePhysics)])
            [obj performSelector:@selector(didSimulatePhysics)];
    }
}
@end





@implementation PlayerShot
//
- (id)initWithPos:(CGPoint)pos dir:(f32)dir speed:(f32)speed {
    if (self = [super init]) {
        self.updateFunction = @selector(updateInit:);
        SKTexture* base = [SKTexture textureWithImageNamed:@"main"];
        SKTexture* tex = [SKTexture textureWithRect:[GameUtil calcWithUV:CGRectMake(16, 64-8+1, 7, 7) inTexture:base] inTexture:base];
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
        SKTexture* tex = [SKTexture textureWithRect:[GameUtil calcWithUV:CGRectMake(0, 64-16, 16, 16) inTexture:base] inTexture:base];
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
        SKTexture* tex = [SKTexture textureWithRect:[GameUtil calcWithUV:CGRectMake(0, 64-32, 16, 16) inTexture:base] inTexture:base];
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
