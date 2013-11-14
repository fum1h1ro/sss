//
//  DisplayView.h
//  sss
//
//  Created by Kanaya Fumihiro on 2013/11/14.
//  Copyright (c) 2013年 alwaystesting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>

@interface DisplayView : UIView
@property (strong, nonatomic) UIView* view;
+ (DisplayView*)shared;
@end
