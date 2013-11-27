#import "GameCommon.h"
#import "GameCamera.h"
#import "GameObject.h"
#import "GameObjectManager.h"

@interface GameScene : SKScene<SKPhysicsContactDelegate> {
    GameObjectManager* _objectManager;
    GameCamera* _camera;
    SEL _selector, _nextSelector;
}
@property (strong, nonatomic) GameObjectManager* objectManager;
@property (strong, nonatomic) GameCamera* camera;
@property (assign, nonatomic) SEL nextSelector;
+ (GameScene*)scene;
+ (SKEmitterNode*)createEmitterNode:(NSString*)name;
- (void)beforeObjectUpdate;
- (void)afterObjectUpdate;
@end
