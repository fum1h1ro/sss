//
//  Enemy.m
//  sss
//
//  Created by Kanaya Fumihiro on 2013/12/04.
//  Copyright (c) 2013年 alwaystesting. All rights reserved.
//

#import "Enemy.h"
#import "SceneMain.h"

@implementation Enemy
//
- (instancetype)initWithPos:(CGPoint)pos {
    if (self = [super init]) {
        _position = pos;
        self.updateFunction = @selector(updateNormal:);
        _hp = 1;
    }
    return self;
}
//
- (void)updateCommon {
    if (_sprite) {
        [self applyPosture:_sprite];
        _sprite.colorBlendFactor = _damage;
    }
    _damage *= 0.8f;
}
//
- (void)updateNormal:(GameObjectManager*)manager {
#if 0
    if (self.lifeTime == 0.0f) {
        if (_preferNodeToAdd) {
            [_preferNodeToAdd addChild:_sprite];
        } else {
            [manager.scene.camera addChild:_sprite];
        }
    }
#endif
    [self evaluateScript:manager];
    [self move];
    [self updateCommon];
    [self checkDead:manager];
}
//
- (void)didBeginContact:(SKPhysicsContact*)contact with:(GameObject*)other {
}
//
- (void)didSimulatePhysics {
}
//
- (void)move {
    const f32 dt = [GameTimer shared].deltaTime;
    f32 spd = _speed * dt;
    _dir += _steer * dt;
    _position.x += cos(GAME_D2R(_dir)) * spd;
    _position.y += sin(GAME_D2R(_dir)) * spd;
    _rotation = GAME_D2R(_dir);
}
//
- (void)setCode:(EnemyScriptCode*)code length:(u32)len {
    _code = code;
    _length = len;
}
//
- (void)checkDead:(GameObjectManager*)manager {
    if (_hp <= 0) {
        SceneMain* scene = (SceneMain*)manager.scene;
        SKEmitterNode* emitter;
        if (_size > 1) {
            emitter = [scene.bombEffect hireInstance];
        } else {
            emitter = [scene.smallBombEffect hireInstance];
        }
        emitter.zPosition = +100;
        emitter.position = _sprite.position;
        if (emitter.parent)
            [emitter removeFromParent];
        emitter.targetNode = _sprite.parent;
        [_sprite.parent addChild:emitter];
        [emitter resetSimulation]; // resetSimulationは、ノードを追加してから呼ばないとダメらしい
        [self removeReservation];
        [[Profile shared] addScore:_score];
        if (_bonus > 0) {
            [scene addBonus:_bonus];
        }
        if (_cbonus) {
            [scene addContinuousBonus:_cbonus];
        }
    }
}
//
- (void)applyDamage {
    _hp -= 1;
    _damage = 1.0f;
}
//
- (void)evaluateScript:(GameObjectManager*)manager {
    if (!_code) return;
    if (!_pc) _pc = _code;
    const f32 dt = [GameTimer shared].deltaTime;
    BOOL yield = NO;
    for (;;) {
        u32 len = _pc - _code;
        if (len >= _length) break;
        if (_wait > 0.0f) {
            _wait = fmax(_wait - dt, 0.0f);
            break;
        }
        switch (_pc->opcode) {
            case _OP_WAIT:
                _wait = (f32)_pc->param * 0.01f;
                ++_pc;
                break;
            case _OP_TEX:
                {
                    s32 x = (_pc->param >> 0) & 0xff;
                    s32 y = (_pc->param >> 8) & 0xff;
                    s32 w = (_pc->param >> 16) & 0xff;
                    s32 h = (_pc->param >> 24) & 0xff;
                    if (_sprite) {
                        if (_sprite.parent) [_sprite removeFromParent];
                        _sprite = nil;
                    }
                    _sprite = [self makeSpriteNode:@"main" rect:CGRectMake(x, y, w, h)];
                    _sprite.zPosition = (CGFloat)kOBJ_ZPOSITION_ENEMY_IN_AIR;
                    _sprite.color = [SKColor blackColor];
                    [_manager.scene.camera addChild:_sprite];
                    ++_pc;
                }
                break;
            case _OP_SPEED:
                _speed = (f32)_pc->param;
                ++_pc;
                break;
            case _OP_DIR:
                _dir = (f32)_pc->param;
                ++_pc;
                break;
            case _OP_ROTATE:
                _steer = (f32)_pc->param;
                ++_pc;
                break;
            case _OP_HP:
                _hp = _pc->param;
                ++_pc;
                break;
            case _OP_HITRECT:
                {
                    s32 w = (_pc->param >> 0) & 0xffff;
                    s32 h = (_pc->param >> 16) & 0xffff;
                    if (_sprite) {
                        SKPhysicsBody* pb = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(w, h)];
                        pb.affectedByGravity = NO;
                        pb.dynamic = NO;
                        pb.mass = 0;
                        pb.restitution = 0;
                        pb.categoryBitMask = kHITBIT_ENEMY_IN_AIR;
                        pb.collisionBitMask = kHITBIT_PLAYER;
                        pb.contactTestBitMask = kHITBIT_PLAYER;
                        _sprite.physicsBody = pb;
                    }
                    ++_pc;
                }
                break;
            case _OP_HITCIRCLE:
                {
                    s32 r = _pc->param;
                    if (_sprite) {
                        SKPhysicsBody* pb = [SKPhysicsBody bodyWithCircleOfRadius:r];
                        pb.affectedByGravity = NO;
                        pb.dynamic = NO;
                        pb.mass = 0;
                        pb.restitution = 0;
                        pb.categoryBitMask = kHITBIT_ENEMY_IN_AIR;
                        pb.collisionBitMask = kHITBIT_PLAYER;
                        pb.contactTestBitMask = kHITBIT_PLAYER;
                        _sprite.physicsBody = pb;
                    }
                    ++_pc;
                }
                break;
            case _OP_JMP:
                {
                    _pc = &_code[_pc->param];
                }
                break;
            case _OP_SHOT:
                {
                    f32 d = _pc->param;
                    f32 spd = 96.0f;//固定
                    // 角度が負なら、自機を狙って撃つ
                    SceneMain* scene = manager.scene;
                    if (d < 0 && scene.player != nil) {
                        Player* player = scene.player;
                        d = atan2(player.position.y - _position.y, player.position.x - _position.x);
                    }
                    EnemyShot* shot = [[EnemyShot alloc] initWithPos:_position speed:spd dir:d];
                    [_manager addGameObject:shot];
                }
                ++_pc;
                break;
        }
        if (yield) break;
    }
}


@end
//



#import "EnemyCode.h"





@implementation EnemyInAir
//
- (id)initWithPos:(CGPoint)pos {
    if (self = [super initWithPos:pos]) {
        self.type = kOBJTYPE_ENEMY_IN_AIR;
        self.updateFunction = @selector(updateNormal:);
        _position = pos;
#if 0
        SKTexture* base = [SKTexture textureWithImageNamed:@"main"];
        SKTexture* tex = [SKTexture textureWithRect:[GameUtil calcWithUV:CGRectMake(32, 8, 16, 16) inTexture:base] inTexture:base];
        _sprite = [SKSpriteNode spriteNodeWithTexture:tex];
        _sprite.userData = [@{@"GameObject" : self} mutableCopy];
        //sprite.size = CGSizeMake(160, 160);
        _sprite.zPosition = (CGFloat)kOBJ_ZPOSITION_ENEMY_IN_AIR;
        _sprite.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:8.0f];
        _sprite.physicsBody.affectedByGravity = NO;
        //_sprite.physicsBody.dynamic = NO;
        _sprite.physicsBody.mass = 0;
        _sprite.physicsBody.restitution = 0;
        _sprite.physicsBody.collisionBitMask = kHITBIT_PLAYER;
        _sprite.physicsBody.categoryBitMask = kHITBIT_ENEMY_ON_GROUND;
        _sprite.physicsBody.contactTestBitMask = kHITBIT_PLAYER;
        //
        _sprite.color = [SKColor blackColor];
        [self applyPosture:_sprite];
#endif
    }
    return self;
}
// 何かに当たった
- (void)didBeginContact:(SKPhysicsContact*)contact with:(GameObject*)other {
    //_damage = 1.0f;
    //_hp -= 1;
    [(Player*)other damage];
}
//
- (void)updateNormal:(GameObjectManager*)manger {
    SceneMain* scene = (SceneMain*)_manager.scene;
    if (!_visible) {
        if ([scene includeRectHorizontally:CGRectMake(_position.x, _position.y, 16, 16)]) {
            _visible = YES;
        }
    } else
    if (![scene includeRectHorizontally:CGRectMake(_position.x, _position.y, 16, 16)]) {
        [self removeReservation];
    }
    [self evaluateScript:_manager];
    [self move];
    [self updateCommon];
    [self checkDead:_manager];
}
















@end






// 地上敵
@implementation EnemyOnGround
//
- (id)initWithPos:(CGPoint)pos texture:(SKTexture*)tex {
    if (self = [super initWithPos:pos]) {
        self.type = kOBJTYPE_ENEMY_ON_GROUND;
        self.updateFunction = @selector(updateNormal:);
        // SKSpriteNodeのanchorPointで中心点からの表示位置を変更しても、
        // SKPhysicsBodyの中心点は変更にならない、かつ変更できないので、諦めて位置をずらす
        CGSize texsz = tex.size;
        _position = CGPointMake(pos.x + texsz.width * 0.5f, pos.y + texsz.height * 0.5f);
        _sprite = [SKSpriteNode spriteNodeWithTexture:tex];
        _sprite.userData = [@{@"GameObject" : self} mutableCopy];
        _sprite.zPosition = (CGFloat)kOBJ_ZPOSITION_ENEMY_ON_GROUND;
        _sprite.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:texsz];
        _sprite.physicsBody.dynamic = NO; // 動かないので
        _sprite.physicsBody.categoryBitMask = kHITBIT_ENEMY_ON_GROUND;
        _sprite.physicsBody.collisionBitMask = kHITBIT_PLAYER_SHOT;
        _sprite.physicsBody.contactTestBitMask = 0;//kHITBIT_PLAYER_SHOT;
        //
        _sprite.color = [SKColor blackColor];
        [self applyPosture:_sprite];
    }
    return self;
}
//
- (void)updateNormal:(GameObjectManager*)manager {
    if (self.lifeTime == 0.0f) {
        if (_preferNodeToAdd) {
            [_preferNodeToAdd addChild:_sprite];
        } else {
            [manager.scene.camera addChild:_sprite];
        }
    }
    [self updateCommon];
    // 画面外（画面下のみ）に消えた場合、自分を消す
    // 横方向をチェックしない理由は、自機の動きでスクロールし、無理矢理消すことが出来てしまうのを防ぐため
    // @bug availableAreaでよくね？
    CGRect vrc = manager.scene.visibleArea;
    CGPoint pt = [_sprite convertPoint:CGPointMake(0, 0) toNode:manager.scene];
    CGSize sz = _sprite.size;
    if (pt.y < vrc.origin.y - sz.height * 0.5f) {
        [self removeReservation];
    }
    [self checkDead:manager];
}
// 何かに当たった
- (void)didBeginContact:(SKPhysicsContact*)contact with:(GameObject*)other {
    //_damage = 1.0f;
    //_hp -= 1;
}
// 物理シミュ部分で、弾が当たったりした後、位置がずれてしまうので、強制的に戻す
- (void)didSimulatePhysics {
    [self applyPosture:_sprite];
}
//
- (void)willRemove {
    // 自分が消滅する時に、同時に何かを生成する指定があれば
    if (self.next && _hp <= 0) {
        // 地上敵は空中の敵と座標系が異なるので要変換
        //  - 一度、シーンの座標系に変換
        CGPoint pos = [_sprite convertPoint:CGPointMake(0, 0) toNode:_manager.scene];
        //  - その後、カメラの座標系に変換
        pos = [_manager.scene convertPoint:pos toNode:_manager.scene.camera];
        Class cls = NSClassFromString(self.next);
        GameObject* obj = [[cls alloc] initWithPos:pos];
        [self.manager addGameObject:obj];
    }
    [super willRemove];
}


@end





@implementation EnemyShot
//
- (id)initWithPos:(CGPoint)pos speed:(f32)speed dir:(f32)dir {
    if (self = [super init]) {
        self.updateFunction = @selector(updateNormal:);
        _position = pos;
        _speed = speed;
        _dir = dir;
        _sprite = [self makeSpriteNode:@"main" rect:CGRectMake(4, 0, 1, 1)];
        _sprite.zPosition = (CGFloat)kOBJ_ZPOSITION_ENEMY_SHOT;
        _sprite.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:2.0f];
        _sprite.physicsBody.affectedByGravity = NO;
        //_sprite.physicsBody.dynamic = NO;
        _sprite.physicsBody.mass = 0;
        _sprite.physicsBody.restitution = 0;
        _sprite.physicsBody.categoryBitMask = kHITBIT_ENEMY_SHOT;
        _sprite.physicsBody.collisionBitMask = kHITBIT_PLAYER;
        _sprite.physicsBody.contactTestBitMask = kHITBIT_PLAYER;
        //
        _sprite.color = [SKColor blackColor];
        [self applyPosture:_sprite];
    }
    return self;
}
//
- (void)updateNormal:(GameObjectManager*)manager {
    if (self.lifeTime == 0.0f && _sprite.parent == nil) {
        [manager.scene.camera addChild:_sprite];
    }
    if (![self isVisible:_sprite]) {
        [self removeReservation];
        return;
    }
    f32 speed = _speed * [GameTimer shared].deltaTime;
    _position.x += cosf(_dir) * speed;
    _position.y += sinf(_dir) * speed;
    _rotation += GAME_D2R(90.0f) * speed;
    [self applyPosture:_sprite];
}
//
- (void)didBeginContact:(SKPhysicsContact*)contact with:(GameObject*)other {
    Player* player = (Player*)other;
    if ([player damage]) {
        [self removeReservation];
    }
}
@end



@implementation EnemyTest
- (instancetype)initWithPos:(CGPoint)pos {
    if (self = [super initWithPos:pos]) {
        [self setCode:table[0].code length:table[0].size];
    }
    return self;
}
@end
@implementation EnemyMiddleBomber
- (instancetype)initWithPos:(CGPoint)pos {
    if (self = [super initWithPos:pos]) {
        [self setCode:table[1].code length:table[1].size];
    }
    return self;
}
@end
