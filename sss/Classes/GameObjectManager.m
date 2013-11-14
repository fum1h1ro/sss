//
//  ObjectManager.m
//  sss
//
//  Created by Kanaya Fumihiro on 2013/11/14.
//  Copyright (c) 2013年 alwaystesting. All rights reserved.
//

#import "GameView.h"
#import "GameScene.h"
#import "GameObjectManager.h"

@implementation GameObject
//
- (id)init {
    if (self = [super init]) {
        _priority = kGAME_OBJECT_DEFAULT_PRIORITY;
    }
    return self;
}
//
- (void)update:(NSTimeInterval)dt {
    if (_updateFunction)
        [self performSelector:_updateFunction];
}
//
- (void)setKill {
    _isKill = YES;
}
@end

@implementation GameObjectManager
//
- (id)initWithScene:(GameScene*)scene {
    if (self = [super init]) {
        self.scene = scene;
        self.array = [NSMutableArray arrayWithCapacity:128];
    }
    return self;
}
// ゲームオブジェクトを追加する
- (void)addGameObject:(GameObject*)obj {
    obj.manager = self;
    [self.array addObject:obj];
    NS_LOG(@"%d", [self.array count]);
    _needsSort = YES;
}
// 
- (void)updateAllGameObject:(NSTimeInterval)dt {
    if (_needsSort) {
        // @todo ソートする
        _needsSort = NO;
    }
    s32 sz = [_array count];
    for (s32 i = 0; i < sz;) {
        GameObject* obj = _array[i];
        [obj update:dt];
        if (obj.isKill) {
            [_array removeObjectAtIndex:i];
        } else {
            ++i;
        }
    }
}

@end










@implementation Player
//
- (id)init {
    if (self = [super init]) {
        _updateFunction = @selector(updateInit:);
    }
    return self;
}
//
- (void)updateInit:(NSTimeInterval)dt {
    SKTexture* base = [SKTexture textureWithImageNamed:@"sss"];
    SKTexture* tex = [SKTexture textureWithRect:CGRectMake(0, 0, 0.5f, 0.5f) inTexture:base];
    SKSpriteNode* sprite = [SKSpriteNode spriteNodeWithTexture:tex];
    sprite.size = CGSizeMake(160, 160);
    sprite.position = CGPointMake(160, 240);
    //SKAction *action = [SKAction rotateByAngle:M_PI duration:31];
    //[sprite runAction:[SKAction repeatActionForever:action]];
    //tex.textureRect = CGRectMake(0, 0, 0.5f, 0.5f);
    [self.manager.scene addChild:sprite];

    _updateFunction = @selector(updateNormal:);
}
//
- (void)updateNormal:(NSTimeInterval)dt {
}




@end
