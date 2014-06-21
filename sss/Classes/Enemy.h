//
//  Enemy.h
//  sss
//
//  Created by Kanaya Fumihiro on 2013/12/04.
//  Copyright (c) 2013年 alwaystesting. All rights reserved.
//

#import "Game.h"
#import "const.h"
#import "EnemyScript.h"
#import "Profile.h"

@interface Enemy : GameObject {
    CGFloat _damage;
    __weak SKNode* _preferNodeToAdd;
    s32 _hp, _score, _bonus, _size;
    f32 _speed, _dir, _steer;
    //
    u32 _length;
    EnemyScriptCode* _code;
    EnemyScriptCode* _pc;
    f32 _wait;
}
@property (weak, nonatomic) SKNode* preferNodeToAdd;
@property (assign, nonatomic) s32 hp;
@property (assign, nonatomic) s32 score;
@property (assign, nonatomic) s32 bonus;
@property (strong, nonatomic) NSArray* cbonus;
@property (assign, nonatomic) s32 size;
@property (strong, nonatomic) NSString* next;
- (id)initWithPos:(CGPoint)pos;
- (void)setCode:(EnemyScriptCode*)code length:(u32)len;
- (void)updateCommon;
- (void)checkDead:(GameObjectManager*)manager;
- (void)applyDamage;
@end
// 空中の敵
@interface EnemyInAir : Enemy {
    BOOL _visible;
}
@end
// 地上の敵
@interface EnemyOnGround : Enemy {
}
- (id)initWithPos:(CGPoint)pos texture:(SKTexture*)tex;
@end
//
@interface EnemyShot : GameObject {
    f32 _speed, _dir;
}
- (id)initWithPos:(CGPoint)pos speed:(f32)speed dir:(f32)dir;
@end
//
@interface EnemyTest : EnemyInAir
@end
@interface EnemyMiddleBomber : EnemyInAir
@end
