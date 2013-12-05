#import "Game.h"
#import "const.h"
#import "Background.h"



@implementation Background
- (id)initWithTMXFile:(NSString*)path size:(CGSize)sz {
    if (self = [super init]) {
        // 背景表示用ノードを用意する
        _bgNode = [[GameBGNode alloc] initWithTMXFile:path size:sz];
        _bgNode.nodeCenter = CGPointMake(sz.width / 2.0f, sz.height / 2.0f);
        CGSize mapsz = _bgNode.mapSize;
        CGSize tilesz = _bgNode.tileSize;
        _bgNode.zPosition = (CGFloat)kOBJ_ZPOSITION_BACKGROUND;
        [_bgNode updateNodes];
        _originNode = [SKNode node];
        self.updateFunction = @selector(updateInit:);
        _targetPosition = CGPointMake((mapsz.width * tilesz.width) / 2.0f, 0);
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
    pt.y += 0.25f;
    _targetPosition = pt;
    [self updateNodes];
}
// 設定されたtargetPositionから、各種ノードを設定する
- (void)updateNodes {
    _bgNode.targetPosition = _targetPosition;
    [_bgNode updateNodes];
    CGSize sz = _bgNode.screenSize;
    _originNode.position = CGPointMake(sz.width * 0.5f -_targetPosition.x, sz.height * 0.5f -_targetPosition.y);
}
@end
