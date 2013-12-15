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
//
@interface GameInstancePool : NSObject {
    NSMutableArray* _pool;
    u32 _size, _available;
}
@property (assign, nonatomic, readonly) u32 size;
@property (assign, nonatomic, readonly) u32 available;
- (id)initWithNumOfStock:(u32)num;
- (id)createInstance;
- (id)allocInstance;
- (id)releaseInstance;
@end
//
@interface GameInstanceRevolver : NSObject {
    NSMutableArray* _pool;
    u32 _size, _index;
}
@property (assign, nonatomic, readonly) u32 size;
- (id)initWithNumOfStock:(u32)num;
- (void)createInstances;
- (id)createInstance;
- (id)hireInstance;
@end
