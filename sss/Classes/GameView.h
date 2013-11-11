//
//  GameView.h
//  sss
//
//  Created by Kanaya Fumihiro on 2013/11/09.
//  Copyright (c) 2013”N alwaystesting. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface GameView : SKView {
    UIView* _touchView;
    UIView* _frameView;
}
@property (assign, readonly, nonatomic) BOOL isInch4;
@property (assign, nonatomic) BOOL touch;
@property (assign, nonatomic) CGPoint touchPos;
- (void)layoutSubviewsLocal;
@end
