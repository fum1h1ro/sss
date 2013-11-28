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
        NSString* path = [[NSBundle mainBundle] pathForResource:@"stage" ofType:@"tmxbin"];
        CGSize sz = self.size;
        u32 w = (u32)(sz.width / 16.0f) + 1;
        u32 h = (u32)(sz.height / 16.0f) + 1;
        _bg = [[GameBGNode alloc] initWithTMXFile:path width:w height:h];
        [self addChild:_bg];
        _bg.nodeCenter = CGPointMake(sz.width / 2.0f, sz.height / 2.0f);
        _bg.targetPosition = CGPointMake(sz.width / 2.0f, 0);
        [_bg updateNodes];
    }
    return self;
}
- (void)beforeObjectUpdate {
    CGPoint pt = _bg.targetPosition;
    pt.y += 0.1f;
    _bg.targetPosition = pt;
    [_bg updateNodes];
}
@end
