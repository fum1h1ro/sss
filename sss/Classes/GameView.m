// vim: fenc=utf-8
#import "GameView.h"

@implementation GameView
//
- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _sceneStack = [NSMutableArray arrayWithCapacity:8];
        _textureStack = [NSMutableArray arrayWithCapacity:8];
//#ifdef DEBUG
        self.backgroundColor = [UIColor greenColor];
        self.showsFPS = YES;
        self.showsDrawCount = YES;
        self.showsNodeCount = YES;
//#endif
        self.contentScaleFactor = 1.0f;
    }
    return self;
}
//
@dynamic lastTexture;
- (SKTexture*)lastTexture {
    NSUInteger count = [_textureStack count];
    if (count > 0) {
        return _textureStack[count-1];
    }
    return nil;
}
@dynamic stackCount;
- (NSUInteger)stackCount {
    return [_sceneStack count];
}
//
- (void)applicationWillResignActive {
    _isActive = NO;
}
// 他のアプリに遷移した時点で呼ばれる
- (void)applicationDidEnterBackground {
    _inBackground = YES;
}
// 再度選択された時に呼ばれる（applicationDidBecomeActive:より先に呼ばれる
- (void)applicationWillEnterForeground {
    _inBackground = NO;
}
// 再度選択された時に呼ばれる（applicationWillEnterForeground:より後に呼ばれる
- (void)applicationDidBecomeActive {
    _isActive = YES;
}
//
- (void)internalPushScene {
    if (self.scene != nil) {
        [_sceneStack addObject:self.scene];
        [_textureStack addObject:[self textureFromNode:self.scene]];
    }
}
//
- (SKScene*)internalPopScene {
    NSUInteger sz = [_sceneStack count];
    if (sz > 0) {
        SKScene* last = _sceneStack[sz-1];
        [_sceneStack removeLastObject];
        [_textureStack removeLastObject];
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
    // スタックを強制的に空にする
    [_sceneStack removeAllObjects];
    [_textureStack removeAllObjects];
    [super presentScene:scene];
}
// 標準のpresentScene:の置き換え
// スタックに積まれているものを全て強制的に空にしてから新しいシーンを表示する(SKTransitionあり
- (void)presentScene:(SKScene*)scene transition:(SKTransition*)transition {
    // スタックを強制的に空にする
    [_sceneStack removeAllObjects];
    [_textureStack removeAllObjects];
    [super presentScene:scene transition:transition];
}
@end
