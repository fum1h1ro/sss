// このメソッドはGameViewからしか呼ばれない
// Objective-Cでfriend相当の機能を実現するための苦肉の策
@implementation VirtualHID(friend)
- (void)touchBegan:(NSSet*)touches {
    _isTouch = YES;
}
- (void)touchEnded:(NSSet*)touches {
    _isTouch = NO;
}
- (void)touchMoved:(NSSet*)touches {
}
@end
