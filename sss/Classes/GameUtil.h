// 
@interface GameUtil : NSObject
+ (void)dumpCGRect:(CGRect)rc;
+ (CGRect)recalcCGRect:(CGRect)inner inRect:(CGRect)base;
+ (CGRect)calcWithUV:(CGRect)uv inTexture:(SKTexture*)texture;
@end
//
@interface GameTimer : NSObject {
    NSTimeInterval _previousTime;
    f32 _deltaTime;
}
@property (assign, nonatomic, readonly) f32 deltaTime;
+ (GameTimer*)shared;
- (void)update:(NSTimeInterval)now;
@end
