//
//  SceneTitle.h
//  sss
//
//  Created by Kanaya Fumihiro on 2013/11/27.
//  Copyright (c) 2013年 alwaystesting. All rights reserved.
//

#import "Game.h"

@interface SceneTitle : GameScene {
    GameButtonNode* _resumeButton;
    SKSpriteNode* _bg;
    NSTimeInterval _wait;
    BOOL _poped;
}
@end
