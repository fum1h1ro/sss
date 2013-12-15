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
    SKSpriteNode* _sprite;
    CGFloat _damage;
    __weak SKNode* _preferNodeToAdd;
    s32 _hp, _score;
    f32 _speed, _dir;
    //
    EnemyScriptCode* _code;
    u32 _length;
    EnemyScriptCode* _pc;
    f32 _register[REG_MAX];
}
@property (weak, nonatomic) SKNode* preferNodeToAdd;
@property (assign, nonatomic) s32 hp;
@property (assign, nonatomic) s32 score;
- (id)initWithPos:(CGPoint)pos;
- (void)setCode:(EnemyScriptCode*)code length:(u32)len;
@end
// 空中の敵
@interface EnemyInAir : Enemy {
}
@end
// 地上の敵
@interface EnemyOnGround : Enemy {
}
@property (assign, nonatomic) s32 size;
- (id)initWithPos:(CGPoint)pos texture:(SKTexture*)tex;
@end
//
@interface EnemyShot : GameObject {
    SKSpriteNode* _sprite;
    f32 _speed, _dir;
}
- (id)initWithPos:(CGPoint)pos speed:(f32)speed dir:(f32)dir;
@end
