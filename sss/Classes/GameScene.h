#import "GameCommon.h"
#import "GameObjectManager.h"

@interface GameScene : SKScene
@property (strong, nonatomic) GameObjectManager* objectManager;
+ (GameScene*)scene;
+ (SKEmitterNode*)createEmitterNode:(NSString*)name;
@end
