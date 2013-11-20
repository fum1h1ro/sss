// 
@interface GameUtil : NSObject
+ (void)dumpCGRect:(CGRect)rc;
+ (CGRect)recalcCGRect:(CGRect)inner inRect:(CGRect)base;
@end
