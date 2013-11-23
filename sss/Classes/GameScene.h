#import "GameCommon.h"
#import "GameCamera.h"
#import "GameObject.h"
#import "GameObjectManager.h"

@interface GameScene : SKScene<SKPhysicsContactDelegate>
@property (strong, nonatomic) GameObjectManager* objectManager;
@property (strong, nonatomic) GameCamera* camera;
+ (GameScene*)scene;
+ (SKEmitterNode*)createEmitterNode:(NSString*)name;
@end
