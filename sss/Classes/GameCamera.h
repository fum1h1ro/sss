//
//  GameCamera.h
//  sss
//
//  Created by Kanaya Fumihiro on 2013/11/20.
//  Copyright (c) 2013年 alwaystesting. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface GameCamera : SKNode {
    f32 _twist;
}
@property (assign, nonatomic) CGPoint target;
- (void)update;
@end
