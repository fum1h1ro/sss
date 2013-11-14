//
//  DisplayView.m
//  sss
//
//  Created by Kanaya Fumihiro on 2013/11/14.
//  Copyright (c) 2013年 alwaystesting. All rights reserved.
//

#import "DisplayView.h"

static DisplayView* instance = nil;

@implementation DisplayView
+ (DisplayView*)shared {
    return instance;
}
- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        instance = self;
        CALayer* ca = self.layer;
        //ca.contentsScale = 0.25f;
        ca.minificationFilter = kCAFilterNearest;
        ca.magnificationFilter = kCAFilterNearest;
    }
    return self;
}
//
- (void)drawRect:(CGRect)rect {
    // Drawing code
    if (_view == nil) return;
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(context, kCGInterpolationNone);

    //[(CALayer*)_view.layer drawInContext:context];
    //CGContextDrawImage(context, CGRectMake(0, 0, 120, 120), CFBridgingRetain((_view.layer.contents)));
    //CGContextSetRGBFillColor(context, 0, 0, 1, 1);
    //CGContextFillRect(context, CGRectMake(0, 0, 90, 90));

    //[(CALayer*)_gameView.layer renderInContext:context];
    //[_gameView drawViewHierarchyInRect:CGRectMake(0, 0, 320, 480) afterScreenUpdates:NO];
}
//
- (void)setView:(UIView*)v {
    if (_view) {
        [_view removeFromSuperview];
    }
    _view = v;
    CALayer* ca = _view.layer;
    //ca.contentsScale = 0.25f;
    ca.minificationFilter = kCAFilterNearest;
    ca.magnificationFilter = kCAFilterNearest;
    _view.frame = CGRectMake(0, 0, 320, 480);
    //_view.hidden = YES;
    //_view.transform = CGAffineTransformMakeScale(10, 10);
    [self addSubview:_view];
}
@end

