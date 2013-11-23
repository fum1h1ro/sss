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
    NSTimeInterval timestamp;
    for (UITouch* touch in touches) {
        _touchPosition = [touch locationInView:self];
        timestamp = touch.timestamp;
    }
    [[GameHID shared] touchesBegan:_touchPosition withTimeStamp:timestamp];
    // 上位層にイベントを投げる
    [super touchesBegan:touches withEvent:event];
}
- (void)touchesCancelled:(NSSet*)touches withEvent:(UIEvent*)event {
    _isHolding = NO;
    NS_LOG(@"CANCEL");
}
- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event {
    _isHolding = NO;
    NSTimeInterval timestamp;
    for (UITouch* touch in touches) {
        _touchPosition = [touch locationInView:self];
        timestamp = touch.timestamp;
    }
    [[GameHID shared] touchesEnded:_touchPosition withTimeStamp:timestamp];
    [super touchesEnded:touches withEvent:event];
}
- (void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event {
    _isHolding = YES;
    NSTimeInterval timestamp;
    for (UITouch* touch in touches) {
        _touchPosition = [touch locationInView:self];
        timestamp = touch.timestamp;
    }
    [[GameHID shared] touchesMoved:_touchPosition withTimeStamp:timestamp];
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
