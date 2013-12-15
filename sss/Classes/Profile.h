//
//  Profile.h
//  sss
//
//  Created by Kanaya Fumihiro on 2013/12/09.
//  Copyright (c) 2013年 alwaystesting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Game.h"

@interface Profile : NSObject
+ (Profile*)shared;
@property (assign, nonatomic) s64 score;
@property (assign, nonatomic) s64 hiScore;
@end
