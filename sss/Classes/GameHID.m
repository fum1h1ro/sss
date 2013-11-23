#import "GameHID.h"
@implementation GameHID
+ (GameHID*)shared {
    static GameHID* shared_ = nil;
    @synchronized(self) {
        if (shared_ == nil)
            shared_ = [[GameHID alloc] init];
    }
    return shared_;
}
- (id)init {
    if (self = [super init]) {
        _margin = 0.1f;
        _sensitivity = 4.0f;
        _isTouch = NO;
    }
    return self;
}
- (void)update {
    //if (_touchTimeStamp == _processTimeStamp) return;
    if (_isTouch) {
        GLKVector2 diff = GLKVector2Make(_touchPosition.x - _previousPosition.x, -(_touchPosition.y - _previousPosition.y));
        //NS_LOG(@"%f %f", diff.x, diff.y);
        f32 len = GLKVector2Length(diff);
        if (len < _margin) {
            diff.x = diff.y = 0.0f;
        } else {
            diff.x *= 1.0f/_sensitivity;
            diff.y *= 1.0f/_sensitivity;
        }
        if (len > 1.0f) {
            diff = GLKVector2Normalize(diff);
        }
        _leftStick.x = diff.x;
        _leftStick.y = diff.y;
        _previousPosition = _touchPosition;
    } else {
        _leftStick.x *= 0.5f;
        _leftStick.y *= 0.5f;
        //_leftStick = CGPointMake(0, 0);
    }
    _processTimeStamp = _touchTimeStamp;
}
- (void)touchesBegan:(CGPoint)pos withTimeStamp:(NSTimeInterval)timestamp {
    _isTouch = YES;
    _touchPosition = _previousPosition = pos;
    _touchTimeStamp = timestamp;
}
- (void)touchesEnded:(CGPoint)pos withTimeStamp:(NSTimeInterval)timestamp {
    _isTouch = NO;
    _touchPosition = pos;
    _touchTimeStamp = timestamp;
}
- (void)touchesMoved:(CGPoint)pos withTimeStamp:(NSTimeInterval)timestamp {
    _touchPosition = pos;
    _touchTimeStamp = timestamp;
}
@end
