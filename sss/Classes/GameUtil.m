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
// 左上基準の非正規化座標から、左下基準の正規化座標に書き換える
+ (CGRect)calcWithUV:(CGRect)uv inTexture:(SKTexture*)texture {
    CGSize sz = [texture size];
    CGRect st = CGRectMake(uv.origin.x, uv.origin.y, uv.size.width, uv.size.height);
    st.origin.y = sz.height - st.origin.y - st.size.height;
    st.origin.x /= sz.width;
    st.origin.y /= sz.height;
    st.size.width /= sz.width;
    st.size.height /= sz.height;
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
    const f32 oneframe = (1.0f/60.0f);
    if (_previousTime == 0.0f) {
        _deltaTime = (f32)oneframe;
    } else {
        _deltaTime = fmin((f32)(now - _previousTime), oneframe * 4.0f);
    }
    if (_deltaTime <= 0.0f) {
        _deltaTime = oneframe;
    }
    _previousTime = now;
}
@end


// インスタンスを予め確保しておき、必要な時に貸し出す
// このままだと、NSObjectを返すので、必要なクラスを生成するように継承先で書き換える
@implementation GameInstancePool
@dynamic available;
//
- (id)initWithNumOfStock:(u32)num {
    if (self = [super init]) {
        _size = num;
        _pool = [NSMutableArray arrayWithCapacity:num];
        for (u32 i = 0; i < num; ++i) {
            [_pool addObject:[self createInstance]];
        }
    }
    return self;
}
// ここをオーバーライドする
- (id)createInstance {
    return [[NSObject alloc] init];
}
//
- (id)allocInstance {
    u32 num = [_pool count];
    if (num > 0) {
        id item = _pool[num-1];
        [_pool removeLastObject];
        return item;
    }
    return nil;
}
//
- (void)releaseInstance:(id)ins {
    [_pool addObject:ins];
}
//
- (u32)available {
    return [_pool count];
}
@end
// インスタンスを予め確保しておき、必要な時に貸し出す
// このままだと、NSObjectを返すので、必要なクラスを生成するように継承先で書き換える
// GameInstancePoolとの違いは、貸し出したものはこのクラスの中にとどまり続ける
// 順番に貸し出され、一周したらまた貸し出される
@implementation GameInstanceRevolver
//
- (id)initWithNumOfStock:(u32)num {
    if (self = [super init]) {
        _size = num;
        _pool = [NSMutableArray arrayWithCapacity:num];
    }
    return self;
}
//
- (void)createInstances {
    for (u32 i = 0; i < _size; ++i) {
        [_pool addObject:[self createInstance]];
    }
}
// ここをオーバーライドする
- (id)createInstance {
    return [[NSObject alloc] init];
}
//
- (id)hireInstance {
    id obj = _pool[_index];
    if ((_index += 1) >= _size) {
        _index = 0;
    }
    return obj;
}
@end
