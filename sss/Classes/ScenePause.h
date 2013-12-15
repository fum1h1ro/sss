//
//  ScenePause.h
//  sss
//
//  Created by Kanaya Fumihiro on 2013/12/01.
//  Copyright (c) 2013年 alwaystesting. All rights reserved.
//

#import "Game.h"

@interface ScenePause : GameScene {
    GameButtonNode* _resumeButton;
    SKSpriteNode* _bg;
    NSTimeInterval _wait;
    BOOL _poped;
}

@end
