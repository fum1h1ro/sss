#import "GameCommon.h"
// 
@interface GameHID : NSObject {
    CGPoint _touchPosition, _previousPosition;
}
@property (readonly, nonatomic) CGPoint leftStick;
@property (readonly, nonatomic) BOOL isTouch;
+ (GameHID*)shared;
- (void)touchesBegan:(CGPoint)pos;
- (void)touchesEnded:(CGPoint)pos;
- (void)touchesMoved:(CGPoint)pos;
- (void)update;
@end
