//
//  GameButtonNode.m
//  sss
//
//  Created by Kanaya Fumihiro on 2013/12/05.
//  Copyright (c) 2013年 alwaystesting. All rights reserved.
//

#import "Game.h"

@implementation GameButtonNode
//
- (id)initWithFontNamed:(NSString*)fontname {
    if (self = [super initWithFontNamed:fontname]) {
        self.userInteractionEnabled = YES;
        self.color = [SKColor grayColor];
    }
    return self;
}
//
- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event {
    //NS_LOG(@"BEGAN");
    if (_touched) return;
    _cancelled = NO;
    self.colorBlendFactor = 1.0f;
}
//
- (void)touchesCancelled:(NSSet*)touches withEvent:(UIEvent*)event {
    NS_LOG(@"CANCELLED");
    if (_touched) return;
}
//
- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event {
    //NS_LOG(@"ENDED");
    if (_touched || _cancelled) return;
    UITouch* touch = [touches anyObject];
    if ([self checkTouchesInside:touch]) {
        NS_LOG(@"OK");
        self.colorBlendFactor = 0.5f;
        _touched = YES; // 一度タッチ状態になると、外部から解除しない限り二度とタッチさせない
    }
}
//
- (void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event {
    //NS_LOG(@"MOVED");
    if (_touched) return;
    UITouch* touch = [touches anyObject];
    if (![self checkTouchesInside:touch]) {
        _cancelled = YES;
        self.colorBlendFactor = 0.0f;
    }
}
//
- (BOOL)checkTouchesInside:(UITouch*)touch {
    CGPoint pt = [touch locationInNode:self.scene];
    SKNode* node = [self.scene nodeAtPoint:pt];
    return node == self;
}
@end
