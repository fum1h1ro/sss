//
//  VirtualHID.m
//  sss
//
//  Created by Kanaya Fumihiro on 2013/11/09.
//  Copyright (c) 2013年 alwaystesting. All rights reserved.
//

#import "VirtualHID.h"
static VirtualHID* shared_ = nil;
@implementation VirtualHID
+ (VirtualHID*)shared {
    if (shared_ == nil)
        shared_ = [[VirtualHID alloc] init];
    return shared_;
}
- (id)init {
    if (self = [super init]) {
        _isTouch = NO;
        _touchPos = CGPointMake(0, 0);
    }
    return self;
}
- (void)touchesBegan:(NSSet*)touches {
    _isTouch = YES;
}
- (void)touchesEnded:(NSSet*)touches {
    _isTouch = NO;
}
- (void)touchesMoved:(NSSet*)touches {
}
@end
