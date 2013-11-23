#import "GameCommon.h"
// 
@interface GameHID : NSObject {
    CGPoint _touchPosition, _previousPosition;
    NSTimeInterval _touchTimeStamp, _processTimeStamp;
}
@property (readonly, nonatomic) CGPoint leftStick; // 仮想スティック
@property (readonly, nonatomic) BOOL isTouch;
@property (assign, nonatomic) f32 margin;
@property (assign, nonatomic) f32 sensitivity;
+ (GameHID*)shared;
- (void)touchesBegan:(CGPoint)pos withTimeStamp:(NSTimeInterval)timestamp;
- (void)touchesEnded:(CGPoint)pos withTimeStamp:(NSTimeInterval)timestamp;
- (void)touchesMoved:(CGPoint)pos withTimeStamp:(NSTimeInterval)timestamp;
- (void)update;
@end
