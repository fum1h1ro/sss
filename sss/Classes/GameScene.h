#import "GameCommon.h"
#import "GameCamera.h"
#import "GameObject.h"
#import "GameObjectManager.h"
#import "GameView.h"

@interface GameScene : SKScene<SKPhysicsContactDelegate> {
    GameObjectManager* _objectManager;
    GameCamera* _camera;
    SEL _selector, _nextSelector;
    CGRect _visibleArea;
}
@property (strong, nonatomic) GameObjectManager* objectManager;
@property (strong, nonatomic) GameCamera* camera;
@property (assign, nonatomic) SEL nextSelector;
@property (readonly, nonatomic) GameView* gameView;
@property (readonly, nonatomic) CGRect visibleArea;
@property (assign, nonatomic) BOOL shouldPause;
+ (SKEmitterNode*)createEmitterNode:(NSString*)name;
- (void)beforeObjectUpdate;
- (void)afterObjectUpdate;
@end
