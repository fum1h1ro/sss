//
//  GameCamera.h
//  sss
//
//  Created by Kanaya Fumihiro on 2013/11/20.
//  Copyright (c) 2013年 alwaystesting. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface GameCamera : SKNode {
    GLKVector2 _target;
    f32 _twist;
}
- (void)update;
@end
