// vim: fenc=utf-8
#import "GameTouchView.h"
#import "ViewController.h"
#import "GameHID.h"

static GameTouchView* instance = nil;

@implementation GameTouchView
//
+ (GameTouchView*)shared {
    return instance;
}
//
- (id)initWithFrame:(CGRect)frame {
    if (instance) return nil;
    if (self = [super initWithFrame:frame]) {
        instance = self;
        _isHolding = NO;
    }
    return self;
}

//
- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event {
    _isHolding = YES;
    for (UITouch* touch in touches) {
        _touchPosition = [touch locationInView:self];
    }
    [[GameHID shared] touchesBegan:_touchPosition];
    // 上位層にイベントを投げる
    [super touchesBegan:touches withEvent:event];
}
- (void)touchesCancelled:(NSSet*)touches withEvent:(UIEvent*)event {
    _isHolding = NO;
    NS_LOG(@"CANCEL");
}
- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event {
    _isHolding = NO;
    for (UITouch* touch in touches) {
        _touchPosition = [touch locationInView:self];
    }
    [[GameHID shared] touchesEnded:_touchPosition];
    [super touchesEnded:touches withEvent:event];
}
- (void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event {
    _isHolding = YES;
    for (UITouch* touch in touches) {
        _touchPosition = [touch locationInView:self];
    }
    [[GameHID shared] touchesMoved:_touchPosition];
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
