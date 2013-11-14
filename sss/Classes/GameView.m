// vim: fenc=utf-8
//  GameView.m
//  sss
//  ほげほげ
//  Created by Kanaya Fumihiro on 2013/11/09.
//  Copyright (c) 2013 alwaystesting. All rights reserved.
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
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor greenColor];
#ifdef DEBUG
        self.showsFPS = YES;
        self.showsDrawCount = YES;
        self.showsNodeCount = YES;
#endif
        self.contentScaleFactor = 1.0f;
#if 0
        CAEAGLLayer* layer = (CAEAGLLayer*)self.layer;
        layer.drawableProperties = @{
            kEAGLDrawablePropertyColorFormat : kEAGLColorFormatRGBA8,
            kEAGLDrawablePropertyRetainedBacking : @YES
        };
#endif
    }
    return self;
}
#if 0
//
- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event {
    [[VirtualHID shared] touchesBegan:touches];
    NS_LOG(@"%fx%f", self.frame.size.width, self.frame.size.height);
    [super touchesBegan:touches withEvent:event];
}
- (void)touchesCancelled:(NSSet*)touches withEvent:(UIEvent*)event {
    NS_LOG(@"CANCEL");
}
- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event {
    [[VirtualHID shared] touchesEnded:touches];
    [super touchesEnded:touches withEvent:event];
}
- (void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event {
    [[VirtualHID shared] touchesMoved:touches];
    [super touchesMoved:touches withEvent:event];
}
#endif
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(context, kCGInterpolationNone);

    //[(CALayer*)_gameView.layer drawInContext:context];
    //CGContextDrawImage(context, CGRectMake(0, 0, 50, 50), 
    CGContextSetRGBFillColor(context, 1, 0, 1, 1);
    CGContextFillRect(context, CGRectMake(0, 80, 90, 90));
}
*/
@end
