//
//  AppDelegate.h
//  sss
//
//  Created by Kanaya Fumihiro on 2013/11/08.
//  Copyright (c) 2013年 alwaystesting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "ViewController.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) ViewController* viewcontroller;
@property (strong, nonatomic) AVSpeechSynthesizer* speechSynthesizer;
+ (id)readJSON:(NSString*)name;
@end
