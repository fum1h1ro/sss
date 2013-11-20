#import "GameHID.h"
static GameHID* shared_ = nil;
@implementation GameHID
+ (GameHID*)shared {
    if (shared_ == nil)
        shared_ = [[GameHID alloc] init];
    return shared_;
}
- (id)init {
    if (self = [super init]) {
        _isTouch = NO;
    }
    return self;
}
- (void)update {
    _leftStick = CGPointMake(0, 0);
    if (_isTouch) {
        GLKVector2 diff = GLKVector2Make(_touchPosition.x - _previousPosition.x, -(_touchPosition.y - _previousPosition.y));
        f32 len = GLKVector2Length(diff);
        if (len > 1.0f) {
            diff = GLKVector2Normalize(diff);
        }
        _leftStick.x = diff.x;
        _leftStick.y = diff.y;
        _previousPosition = _touchPosition;
    }
}
- (void)touchesBegan:(CGPoint)pos {
    _isTouch = YES;
    _touchPosition = _previousPosition = pos;
}
- (void)touchesEnded:(CGPoint)pos {
    _isTouch = NO;
    _touchPosition = pos;
}
- (void)touchesMoved:(CGPoint)pos {
    _touchPosition = pos;
}
@end
