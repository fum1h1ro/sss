// vim: fenc=utf-8
#import "GameView.h"

@implementation GameView
//
- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _sceneStack = [NSMutableArray arrayWithCapacity:8];
#ifdef DEBUG
        self.backgroundColor = [UIColor greenColor];
        self.showsFPS = YES;
        self.showsDrawCount = YES;
        self.showsNodeCount = YES;
#endif
        self.contentScaleFactor = 1.0f;
    }
    return self;
}
//
- (void)internalPushScene {
    if (self.scene != nil) {
        [_sceneStack addObject:self.scene];
    }
}
//
- (SKScene*)internalPopScene {
    u32 sz = [_sceneStack count];
    if (sz > 0) {
        SKScene* last = _sceneStack[sz-1];
        [_sceneStack removeLastObject];
        return last;
    }
    return nil;
}
// 現在表示中のシーンをpushして新しいシーンを表示する
- (void)pushScene:(SKScene*)scene {
    [self internalPushScene];
    [super presentScene:scene];
}
// 現在表示中のシーンをpushして新しいシーンを表示する(SKTransitionあり
- (void)pushScene:(SKScene*)scene transition:(SKTransition*)transition {
    [self internalPushScene];
    [super presentScene:scene transition:transition];
}
// 現在表示中のシーンを外し、スタックからpopしたシーンを表示する
- (void)popScene {
    SKScene* scene = [self internalPopScene];
    if (scene) {
        [super presentScene:scene];
    }
}
// 現在表示中のシーンを外し、スタックからpopしたシーンを表示する(SKTransitionあり
- (void)popScene:(SKTransition*)transition {
    SKScene* scene = [self internalPopScene];
    if (scene) {
        [super presentScene:scene transition:transition];
    }
}
// 標準のpresentScene:の置き換え
// スタックに積まれているものを全て強制的に空にしてから新しいシーンを表示する
- (void)presentScene:(SKScene*)scene {
    [_sceneStack removeAllObjects]; // スタックを強制的に空にする
    [super presentScene:scene];
}
// 標準のpresentScene:の置き換え
// スタックに積まれているものを全て強制的に空にしてから新しいシーンを表示する(SKTransitionあり
- (void)presentScene:(SKScene*)scene transition:(SKTransition*)transition {
    [_sceneStack removeAllObjects]; // スタックを強制的に空にする
    [super presentScene:scene transition:transition];
}
@end
