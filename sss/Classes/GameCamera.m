//
//  GameCamera.m
//  sss
//
//  Created by Kanaya Fumihiro on 2013/11/20.
//  Copyright (c) 2013年 alwaystesting. All rights reserved.
//

#import "GameCommon.h"
#import "GameCamera.h"

@implementation GameCamera
//
- (void)update {
    CGPoint pos;
    pos.x = -_target.x;
    pos.y = -_target.y;
    self.position = pos;
    self.zRotation = -_twist;
}
//
@end
