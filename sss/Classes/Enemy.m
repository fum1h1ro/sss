//
//  Enemy.m
//  sss
//
//  Created by Kanaya Fumihiro on 2013/12/04.
//  Copyright (c) 2013年 alwaystesting. All rights reserved.
//

#import "Enemy.h"

@implementation Enemy
//
- (id)initWithPos:(CGPoint)pos {
    if (self = [super init]) {
        self.updateFunction = @selector(updateInit:);
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
        _sprite.color = [SKColor whiteColor];
        [self applyPosture:_sprite];
    }
    return self;
}
//
- (void)updateInit:(GameObjectManager*)manager {
    if (_preferNodeToAdd) {
        [_preferNodeToAdd addChild:_sprite];
    } else {
        [manager.scene.camera addChild:_sprite];
    }
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
    _sprite.colorBlendFactor = _damage;
    _damage *= 0.8f;
}
//
- (void)didBeginContact:(SKPhysicsContact*)contact with:(GameObject*)other {
    _damage = 1.0f;
}
//
- (void)didSimulatePhysics {
}


@end
// 地上敵
@implementation EnemyOnGround
//
- (id)initWithPos:(CGPoint)pos texture:(SKTexture*)tex {
    if (self = [super initWithPos:pos]) {
        self.updateFunction = @selector(updateInit:);
        // SKSpriteNodeのanchorPointで中心点からの表示位置を変更しても、
        // SKPhysicsBodyの中心点は変更にならない、かつ変更できないので、諦めて位置をずらす
        CGSize texsz = tex.size;
        _position = CGPointMake(pos.x + texsz.width * 0.5f, pos.y + texsz.height * 0.5f);
        //SKTexture* base = [SKTexture textureWithImageNamed:@"main"];
        //SKTexture* tex = [SKTexture textureWithRect:[GameUtil calcWithUV:CGRectMake(32, 8, 16, 16) inTexture:base] inTexture:base];
        _sprite = [SKSpriteNode spriteNodeWithTexture:tex];
        _sprite.userData = [@{@"GameObject" : self} mutableCopy];
        //_sprite.anchorPoint = CGPointMake(0, 0);
        _sprite.zPosition = (CGFloat)kOBJ_ZPOSITION_ENEMY_ON_GROUND;
        _sprite.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:texsz];
        _sprite.physicsBody.affectedByGravity = NO;
        _sprite.physicsBody.dynamic = NO;
        _sprite.physicsBody.mass = 0;
        _sprite.physicsBody.categoryBitMask = kHITBIT_ENEMY_ON_GROUND;
        _sprite.physicsBody.collisionBitMask = kHITBIT_PLAYER_SHOT;
        _sprite.physicsBody.contactTestBitMask = kHITBIT_PLAYER_SHOT;
        //
        _sprite.color = [SKColor whiteColor];
        [self applyPosture:_sprite];
        _hp = 5;
    }
    return self;
}
//
- (void)updateInit:(GameObjectManager*)manager {
    if (_preferNodeToAdd) {
        [_preferNodeToAdd addChild:_sprite];
    } else {
        [manager.scene.camera addChild:_sprite];
    }
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
        [self removeReservation];
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
