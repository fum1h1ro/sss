#import "GameCommon.h"
#import "GameUtil.h"

@implementation GameUtil
// CGRectをダンプします
+ (void)dumpCGRect:(CGRect)rc {
    NS_LOG(@"CGRect: %f %f %f %f", rc.origin.x, rc.origin.y, rc.size.width, rc.size.height);
}
// あるCGRectが、指定されたCGRectのうち、どの部分にあたるかを再計算する
+ (CGRect)recalcCGRect:(CGRect)inner inRect:(CGRect)base {
    CGRect newrc;
    newrc.size.width = inner.size.width * base.size.width;
    newrc.size.height = inner.size.height * base.size.height;
    newrc.origin.x = base.origin.x + inner.origin.x * base.size.width;
    newrc.origin.y = base.origin.y + inner.origin.y * base.size.height;
    return newrc;
}

@end
