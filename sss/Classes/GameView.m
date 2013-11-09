//
//  GameView.m
//  sss
//
//  Created by Kanaya Fumihiro on 2013/11/09.
//  Copyright (c) 2013年 alwaystesting. All rights reserved.
//

#import "GameView.h"
#import "VirtualHID.h"
#import "VirtualHID+friend.h"
@implementation GameView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event {
    [[VirtualHID shared] touchBegan:touches];
    [super touchesBegan:touches withEvent:event];
}
- (void)touchesCancelled:(NSSet*)touches withEvent:(UIEvent*)event {
    NSLog(@"CANCEL");
}
- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event {
    [[VirtualHID shared] touchEnded:touches];
    [super touchesEnded:touches withEvent:event];
}
- (void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event {
    [[VirtualHID shared] touchMoved:touches];
    [super touchesMoved:touches withEvent:event];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
