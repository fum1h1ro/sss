#import "GameCommon.h"
#import "GameObjectManager.h"
#import "GameScene.h"
#import "GameHID.h"

@implementation GameScene
- (id)init {
    CGSize size = CGSizeMake(320, 480);
    size.width *= 0.5f;
    size.height *= 0.5f;
    if (self = [super initWithSize:size]) {
        _objectManager = [[GameObjectManager alloc] initWithScene:self];
        //self.scaleMode = SKSceneScaleModeAspectFill;
        self.scaleMode = SKSceneScaleModeFill;
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:1.0 alpha:1.0];

        Player* player = [[Player alloc] init];
        [_objectManager addGameObject:player];
    }
    return self;
}
//
- (void)update:(CFTimeInterval)dt {
    [[GameHID shared] update];
    [_objectManager updateAllGameObject:dt];
#ifdef USE_DISPLAY_VIEW
    UIView* view = [self.view snapshotViewAfterScreenUpdates:NO];
    [DisplayView shared].view = view;
    [[DisplayView shared] setNeedsDisplay];
#endif
}
//
+ (SKEmitterNode*)createEmitterNode:(NSString*)name {
    NSString* path = [[NSBundle mainBundle] pathForResource:name ofType:@"sks"];
    SKEmitterNode* node = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    return node;
}
@end
