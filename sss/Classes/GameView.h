// vim: fenc=utf-8
#import <SpriteKit/SpriteKit.h>
#import "GameCommon.h"

// SKViewを継承したGame表示用ビュー
// SKSceneのスタックを行う機能を追加している
@interface GameView : SKView {
    NSMutableArray* _sceneStack;
}
- (void)pushScene:(SKScene*)scene;
- (void)pushScene:(SKScene*)scene transition:(SKTransition*)transition;
- (void)popScene;
- (void)popScene:(SKTransition*)transition;
- (void)presentScene:(SKScene*)scene;
- (void)presentScene:(SKScene*)scene transition:(SKTransition*)transition;
@end
