//
//  ScenePause.h
//  sss
//
//  Created by Kanaya Fumihiro on 2013/12/01.
//  Copyright (c) 2013年 alwaystesting. All rights reserved.
//

#import "Game.h"

@interface ScenePause : GameScene<UIAlertViewDelegate> {
    GameButtonNode* _titleButton;
    GameButtonNode* _resumeButton;
    SKSpriteNode* _bg;
    NSTimeInterval _wait;
    BOOL _poped, _showAlert;
}

@end
