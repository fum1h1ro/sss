#import "GameCommon.h"
#import "GameUtil.h"
#import "GameObject.h"
#import "GameObjectManager.h"
#import "GameScene.h"
#import "GameHID.h"

@implementation GameScene
@dynamic gameView;
//
- (GameView*)gameView {
    return (GameView*)self.view;
}
//
- (id)init {
    CGSize size = CGSizeMake(320, 480);
    //size.width *= 0.5f;
    //size.height *= 0.5f;
    if (self = [super initWithSize:size]) {
        _objectManager = [[GameObjectManager alloc] initWithScene:self];
        _camera = [[GameCamera alloc] init];
        [self addChild:_camera];
        _camera.zRotation = GAME_D2R(45.0f);
        //self.scaleMode = SKSceneScaleModeAspectFill;
        self.scaleMode = SKSceneScaleModeFill;
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:1.0 alpha:1.0];
        //self.xScale = 0.5f;
        //self.position = CGPointMake(40, 0);
        self.physicsWorld.contactDelegate = self;
    }
    return self;
}
//
- (void)update:(NSTimeInterval)dt {
    [[GameTimer shared] update:dt];
    [[GameHID shared] update];
    [self beforeObjectUpdate];
    [_objectManager updateAllGameObject:dt];
    [_camera update];
    [self afterObjectUpdate];
#ifdef USE_DISPLAY_VIEW
    UIView* view = [self.view snapshotViewAfterScreenUpdates:NO];
    [DisplayView shared].view = view;
    [[DisplayView shared] setNeedsDisplay];
#endif
}
//
- (void)beforeObjectUpdate {
}
//
- (void)afterObjectUpdate {
}
//
- (void)didEvaluateActions {
    [_objectManager didEvaluateActions];
}
//
- (void)didSimulatePhysics {
    [_objectManager didSimulatePhysics];
}
//
+ (SKEmitterNode*)createEmitterNode:(NSString*)name {
    NSString* path = [[NSBundle mainBundle] pathForResource:name ofType:@"sks"];
    SKEmitterNode* node = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    return node;
}
//
- (void)didBeginContact:(SKPhysicsContact*)contact {
    //NS_LOG(@"BEGIN");
    GameObject* objA = contact.bodyA.node.userData[@"GameObject"];
    GameObject* objB = contact.bodyB.node.userData[@"GameObject"];
    if (objA) [objA didBeginContact:contact with:objB];
    if (objB) [objB didBeginContact:contact with:objA];
}
//
- (void)didEndContact:(SKPhysicsContact*)contact {
    //NS_LOG(@"END");
    GameObject* objA = contact.bodyA.node.userData[@"GameObject"];
    GameObject* objB = contact.bodyB.node.userData[@"GameObject"];
    if (objA) [objA didEndContact:contact with:objB];
    if (objB) [objB didEndContact:contact with:objA];
}
@end
