//
//  SceneMain.m
//  sss
//
//  Created by Kanaya Fumihiro on 2013/11/27.
//  Copyright (c) 2013年 alwaystesting. All rights reserved.
//

#import "SceneMain.h"

@implementation SceneMain
- (id)init {
    if (self = [super init]) {
        Player* player = [[Player alloc] init];
        [_objectManager addGameObject:player];
        Enemy* enemy = [[Enemy alloc] init];
        [_objectManager addGameObject:enemy];
        _bg = [[GameBGNode alloc] initWithTMXFile:[[NSBundle mainBundle] pathForResource:@"stage" ofType:@"tmxbin"]];
        [self addChild:_bg];
        _bg.nodeCenter = CGPointMake(80, 120);
        [_bg updateNodes];
    }
    return self;
}
- (void)beforeObjectUpdate {
    static f32 r = 0.0f;
    _bg.targetPosition = CGPointMake(192 + sin(r) * 30.0f, 8);
    r += GAME_PI * 0.05f;
    [_bg updateNodes];
}
@end
