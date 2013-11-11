//
//  GameScene.m
//  sss
//
//  Created by Kanaya Fumihiro on 2013/11/11.
//  Copyright (c) 2013年 alwaystesting. All rights reserved.
//

#import "GameScene.h"

@implementation GameScene
- (id)init {
    CGSize size = CGSizeMake(640, 960);
    if (self = [super initWithSize:size]) {
        self.scaleMode = SKSceneScaleModeAspectFill;
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:1.0 alpha:1.0];
    }
    return self;
}


@end
