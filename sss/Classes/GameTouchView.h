// vim: fenc=utf-8
#import <UIKit/UIKit.h>

@interface GameTouchView : UIView
+ (GameTouchView*)shared;
@property (assign, nonatomic, readonly) BOOL isHolding;
@property (assign, nonatomic, readonly) CGPoint touchPosition;
@end
