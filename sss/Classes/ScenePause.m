//
//  ScenePause.m
//  sss
//
//  Created by Kanaya Fumihiro on 2013/12/01.
//  Copyright (c) 2013年 alwaystesting. All rights reserved.
//

#import "ScenePause.h"

@implementation ScenePause

- (void)beforeObjectUpdate {
    if ([GameHID shared].isTouch) {
        GameView* gameview = _objectManager.scene.gameView;
        [gameview popScene:[SKTransition doorsOpenHorizontalWithDuration:0.5f]];
    }
}
@end
