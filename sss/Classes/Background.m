#import "Game.h"
#import "const.h"
#import "Background.h"
#import "SceneMain.h"


@implementation Background
//
- (id)initWithTMXFile:(NSString*)path size:(CGSize)sz {
    if (self = [super init]) {
        // 背景表示用ノードを用意する
        _bgNode = [[GameBGNode alloc] initWithTMXFile:path size:sz];
        _bgNode.nodeCenter = CGPointMake(0, 0);
        CGSize mapsz = _bgNode.mapSize;
        CGSize tilesz = _bgNode.tileSize;
        _bgNode.zPosition = (CGFloat)kOBJ_ZPOSITION_BACKGROUND;
        [_bgNode updateNodes];
        _originNode = [SKNode node];
        self.updateFunction = @selector(updateInit:);
        _centerX = (mapsz.width * tilesz.width) / 2.0f;
        _offsetX = 0.0f;
        _targetPosition = CGPointMake(_centerX, 0);
        _speed = 32.0f;
    }
    return self;
}
//
- (void)updateInit:(GameObjectManager*)manager {
    [manager.scene addChild:_bgNode];
    [manager.scene addChild:_originNode];
    self.updateFunction = @selector(updateNormal:);
    [self updateNodes];
}
//
- (void)updateNormal:(GameObjectManager*)manager {
    CGPoint pt = _targetPosition;
    pt.y += _speed * [GameTimer shared].deltaTime;
    pt.x = _centerX + _offsetX;
    _targetPosition = pt;
    [self updateNodes];
}
// 設定されたtargetPositionから、各種ノードを設定する
- (void)updateNodes {
    _bgNode.targetPosition = _targetPosition;
    [_bgNode updateNodes];
    //CGSize sz = _bgNode.screenSize;
    _originNode.position = CGPointMake(-_targetPosition.x, -_targetPosition.y);
}
@end
