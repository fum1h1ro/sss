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
//
+ (CGRect)calcWithUV:(CGRect)uv inTexture:(SKTexture*)texture {
    CGSize sz = [texture size];
    CGRect st = CGRectMake(uv.origin.x / sz.width, uv.origin.y / sz.height, uv.size.width / sz.width, uv.size.height / sz.height);
    return st;
}

@end



@implementation GameTimer
+ (GameTimer*)shared {
    static GameTimer* instance = nil;
    @synchronized(self) {
        if (instance == nil) {
            instance = [[GameTimer alloc] init];
        }
    }
    return instance;
}
//
- (void)update:(NSTimeInterval)now {
    _deltaTime = (f32)(now - _previousTime);
    _previousTime = now;
}
@end
