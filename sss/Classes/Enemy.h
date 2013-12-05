//
//  Enemy.h
//  sss
//
//  Created by Kanaya Fumihiro on 2013/12/04.
//  Copyright (c) 2013年 alwaystesting. All rights reserved.
//

#import "Game.h"
#import "const.h"

@interface Enemy : GameObject {
    SKSpriteNode* _sprite;
    CGFloat _damage;
    __weak SKNode* _preferNodeToAdd;
    s32 _hp;
}
@property (weak, nonatomic) SKNode* preferNodeToAdd;
@property (assign, nonatomic) s32 hp;
- (id)initWithPos:(CGPoint)pos;
@end




@interface EnemyOnGround : Enemy {
}
- (id)initWithPos:(CGPoint)pos texture:(SKTexture*)tex;
@end
