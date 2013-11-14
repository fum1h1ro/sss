//
//  ViewController.h
//  sss
//

//  Copyright (c) 2013年 alwaystesting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
#import "GameView.h"

@interface ViewController : UIViewController
@property (assign, nonatomic) BOOL isInch4;
@property (strong, nonatomic) GameView* gameView;
@property (strong, nonatomic) UIView* frameView;
@end
