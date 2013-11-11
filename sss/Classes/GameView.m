// vim: fenc=utf-8
//  GameView.m
//  sss
//
//  Created by Kanaya Fumihiro on 2013/11/09.
//  Copyright (c) 2013”N alwaystesting. All rights reserved.
//

#import "GameView.h"
#import "VirtualHID.h"

#define kSCREEN_WIDTH_NON_RETINA 320
#define kSCREEN_HEIGHT_NON_RETINA 480
#define kSCREEN_WIDTH_35INCH 640
#define kSCREEN_HEIGHT_35INCH 960
#define kSCREEN_WIDTH_4INCH 640
#define kSCREEN_HEIGHT_4INCH 1136

@implementation GameView
//
- (id)initWithFrame:(CGRect)frame {
    CGFloat longer = fmax(frame.size.width, frame.size.height);
    CGRect gameframe = frame;
    _isInch4 = NO;
    if (longer <= kSCREEN_HEIGHT_NON_RETINA) {
        // 4:3
        NSLog(@"4:3");
    } else {
        // ç´„16:9
        NSLog(@"16:9");
        if (frame.size.width < frame.size.height) {
            gameframe.size.height = kSCREEN_HEIGHT_NON_RETINA/2;
        } else {
            gameframe.size.width = kSCREEN_HEIGHT_NON_RETINA;
        }
        _isInch4 = YES;
    }
    if (self = [super initWithFrame:gameframe]) {
        // Initialization code
        [VirtualHID shared];
        self.backgroundColor = [UIColor redColor];
        if (_isInch4) {
            CGFloat h = (kSCREEN_HEIGHT_4INCH/2) - kSCREEN_HEIGHT_NON_RETINA;
            CGRect rc = CGRectMake(0, kSCREEN_HEIGHT_4INCH/2-h, kSCREEN_WIDTH_NON_RETINA, h);
            _frameView = [[UIView alloc] initWithFrame:rc];
            _frameView.backgroundColor = [UIColor whiteColor];
            [self addSubview:_frameView];
        }

    }
    return self;
}
//
- (void)layoutSubviewsLocal {
    if (_isInch4) {
        CGFloat gameh = kSCREEN_HEIGHT_NON_RETINA;
        CGFloat frameh = (kSCREEN_HEIGHT_4INCH/2) - kSCREEN_HEIGHT_NON_RETINA;
        CGRect gamerc = CGRectMake(0, 0, kSCREEN_WIDTH_NON_RETINA, kSCREEN_HEIGHT_NON_RETINA);
        CGRect framerc = CGRectMake(0, gameh, kSCREEN_WIDTH_NON_RETINA, frameh);
        self.frame = gamerc;
        _frameView.frame = framerc;
    }
}
//
- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event {
    [[VirtualHID shared] touchesBegan:touches];
    NSLog(@"%fx%f", self.frame.size.width, self.frame.size.height);
    [super touchesBegan:touches withEvent:event];
}
- (void)touchesCancelled:(NSSet*)touches withEvent:(UIEvent*)event {
    NSLog(@"CANCEL");
}
- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event {
    [[VirtualHID shared] touchesEnded:touches];
    [super touchesEnded:touches withEvent:event];
}
- (void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event {
    [[VirtualHID shared] touchesMoved:touches];
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
