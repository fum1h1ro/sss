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
- (void)updateInit:(GameObjectManager*)manager {
    self.updateFunction = @selector(updateNormal:);
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
    [self evaluateScript:manager];
    [self move];
    if (_sprite) {
        [self applyPosture:_sprite];
        _sprite.colorBlendFactor = _damage;
    }
    _damage *= 0.8f;
}
//
- (void)didBeginContact:(SKPhysicsContact*)contact with:(GameObject*)other {
    _damage = 1.0f;
}
//
- (void)didSimulatePhysics {
}
//
- (void)move {
    f32 dt = [GameTimer shared].deltaTime;
    f32 spd = _speed * dt;
    _position.x += cos(GAME_D2R(_dir)) * spd;
    _position.y += sin(GAME_D2R(_dir)) * spd;
}
//
- (void)setCode:(EnemyScriptCode*)code length:(u32)len {
    _code = code;
    _length = len;
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
        switch (_pc->opcode) {
            case OP_YIELD:
                yield = YES;
                ++_pc;
                break;
            case OP_LI:
                _register[_pc->a] = _pc->b;
                ++_pc;
                break;
            case OP_ADD:
                _register[_pc->a] += _pc->b;
                ++_pc;
                break;
            case OP_SUB:
                _register[_pc->a] -= _pc->b;
                ++_pc;
                break;
            case OP_MUL:
                _register[_pc->a] *= _pc->b;
                ++_pc;
                break;
            case OP_DIV:
                _register[_pc->a] /= _pc->b;
                ++_pc;
                break;
            case OP_SPEED:
                _speed = _register[_pc->a];
                ++_pc;
                break;
            case OP_DIR:
                _dir = _register[_pc->a];
                ++_pc;
                break;
            case OP_ROTATE:
                _dir += _register[_pc->a] * dt;
                ++_pc;
                break;
            case OP_WAIT:
                {
                    f32 w = _register[_pc->a];
                    w -= [GameTimer shared].deltaTime;
                    if (w <= 0.0f) {
                        ++_pc;
                    } else {
                        _register[_pc->a] = w;
                        yield = YES;
                    }
                }
                break;
            case OP_JMP:
                {
                    const u8 lbl = _pc->a;
                    for (int i = 0; i < _length; ++i) {
                        EnemyScriptCode* c = &_code[i];
                        if (c->label == lbl) {
                            _pc = c;
                            break;
                        }
                    }
                }
                break;
            case OP_SHOT:
                {
                    f32 d = _register[_pc->a];
                    f32 spd = _pc->b;
                    // 角度が負なら、自機を狙って撃つ
                    SceneMain* scene = manager.scene;
                    if (d < 0 && scene.player != nil) {
                        Player* player = scene.player;
                        d = atan2(player.position.y - _position.y, player.position.x - _position.x);
                    }
                    EnemyShot* shot = [[EnemyShot alloc] initWithPos:_position speed:spd dir:d];
                    [manager addGameObject:shot];
                }
                ++_pc;
                break;
        }
        if (yield) break;
    }
}


@end
//


static EnemyScriptCode elems[] = {
    { 0, OP_YIELD },
    { 0, OP_LI, REG_A, 270 },
    { 0, OP_DIR, REG_A },
    { 0, OP_LI, REG_B, 50 },
    { 0, OP_SPEED, REG_B },
    { 0, OP_ADD, REG_A, 1 },
    { 1, OP_ROTATE, REG_A },
    { 0, OP_LI, REG_C, -1 },
    //{ 0, OP_SHOT, REG_C, 200 },
    { 0, OP_YIELD },
    { 0, OP_JMP, 1 },
};







@implementation EnemyInAir
//
- (id)initWithPos:(CGPoint)pos {
    if (self = [super init]) {
        self.updateFunction = @selector(updateNormal:);
        _position = pos;
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
        [self setCode:elems length:sizeof(elems)/sizeof(elems[0])];
    }
    return self;
}


















@end






// 地上敵
@implementation EnemyOnGround
//
- (id)initWithPos:(CGPoint)pos texture:(SKTexture*)tex {
    if (self = [super init]) {
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
        _sprite.physicsBody.contactTestBitMask = kHITBIT_PLAYER_SHOT;
        //
        _sprite.color = [SKColor blackColor];
        [self applyPosture:_sprite];
        _hp = 1;
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
    _sprite.colorBlendFactor = _damage;
    _damage *= 0.8f;
    // 画面外（画面下のみ）に消えた場合、自分を消す
    CGRect vrc = manager.scene.visibleArea;
    CGPoint pt = [_sprite convertPoint:CGPointMake(0, 0) toNode:manager.scene];
    CGSize sz = _sprite.size;
    if (pt.y < vrc.origin.y - sz.height * 0.5f) {
        [self removeReservation];
    }
    if (_hp <= 0) {
        SceneMain* scene = (SceneMain*)manager.scene;
        SKEmitterNode* emitter;
        if (_size > 1) {
            emitter = [scene.bombEffect hireInstance];
        } else {
            emitter = [scene.smallBombEffect hireInstance];
        }
        emitter.zPosition = +100;
        emitter.position = pt;
        if (emitter.parent)
            [emitter removeFromParent];
        emitter.targetNode = _manager.scene;//.camera;
        [manager.scene/*.camera*/ addChild:emitter];
        [emitter resetSimulation]; // resetSimulationは、ノードを追加してから呼ばないとダメらしい
        [self removeReservation];
        [Profile shared].score += _score;
    }
}
//
- (void)didBeginContact:(SKPhysicsContact*)contact with:(GameObject*)other {
    _damage = 1.0f;
    _hp -= 1;
}
//
- (void)didSimulatePhysics {
    [self applyPosture:_sprite];
}
//
- (void)willRemove {
    [_sprite removeFromParent];
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
        SKTexture* base = [SKTexture textureWithImageNamed:@"main"];
        SKTexture* tex = [SKTexture textureWithRect:[GameUtil calcWithUV:CGRectMake(32, 0, 8, 8) inTexture:base] inTexture:base];
        _sprite = [SKSpriteNode spriteNodeWithTexture:tex];
        _sprite.userData = [@{@"GameObject" : self} mutableCopy];
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
- (void)willRemove {
    [_sprite removeFromParent];
}
//
- (void)didBeginContact:(SKPhysicsContact*)contact with:(GameObject*)other {
    Player* player = (Player*)other;
    if ([player damage]) {
        [self removeReservation];
    }
}
@end
