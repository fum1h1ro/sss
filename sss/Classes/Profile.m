//
//  Profile.m
//  sss
//
//  Created by Kanaya Fumihiro on 2013/12/09.
//  Copyright (c) 2013年 alwaystesting. All rights reserved.
//

#import "Profile.h"

@implementation Profile
//
+ (Profile*)shared {
    static Profile* instance = nil;
    @synchronized(self) {
        if (instance == nil) {
            instance = [[Profile alloc] init];
        }
    }
    return instance;
}
//
- (void)reset {
    _score = 0;
}
//
- (void)addScore:(s64)sc {
    _score += sc;
    if (_score > _hiScore) {
        _hiScore = _score;
    }
}

@end
