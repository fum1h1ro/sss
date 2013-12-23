// vim: fenc=utf-8
#import "GameCommon.h"
#import "GameObject.h"
#import "GameUtil.h"
#import <objc/message.h>

@implementation GameObject {
    SEL _updateFunction;
    IMP _updateFunctionPtr;
}
@dynamic updateFunction;
- (void)setUpdateFunction:(SEL)func {
    _updateFunction = func;
    _isUpdateFirst = YES;
    _updateFunctionPtr = [self methodForSelector:func];
}
//
- (id)init {
    if (self = [super init]) {
        _priority = kGameObjectDefaultPriority;
    }
    return self;
}
//
- (void)resetAsNewbie {
    _lifeTime = 0;
}
//
- (void)updateByManager {
    if (_updateFunction) {
        //[self performSelector:_updateFunction withObject:manager]; // この書き方だと、コンパイラの警告が出る（支障はないっぽいが
        //_updateFunctionPtr(self, _updateFunction, manager); // この書き方でもいいはずなのだが、何故かGameObjectが二つ以上になるとアクセス違反
        objc_msgSend(self, _updateFunction, self.manager);
        _isUpdateFirst = NO;
    }
    _lifeTime += [GameTimer shared].deltaTime;
}
//
- (void)removeReservation {
    _isRemove = YES;
}
//
- (BOOL)isVisible:(SKNode*)node {
    return [node.scene intersectsNode:node];
}
// オブジェクトマネージャから切り離される前に呼ばれる
// 必要ならここでSKSpriteNodeを切り離したりする
- (void)willRemove {
    if (_sprite) {
        _sprite.userData = nil; // ここで消しておかないと循環参照になる可能性がある
        [_sprite removeFromParent];
        _sprite = nil;
    }
}
//
- (void)didBeginContact:(SKPhysicsContact*)contact with:(GameObject*)other {
}
//
- (void)didEndContact:(SKPhysicsContact*)contact with:(GameObject*)other {
}
//
- (void)applyPosture:(SKNode*)node {
    node.position = _position;
    node.zRotation = _rotation;
}
// SKSpriteNodeを作るサービス関数
// テクスチャ名と8x8パターン単位での領域を指定する
- (SKSpriteNode*)makeSpriteNode:(NSString*)texname rect:(CGRect)rc {
    SKTexture* base = [SKTexture textureWithImageNamed:texname];
    rc.origin.x = (s32)rc.origin.x * 8;
    rc.origin.y = (s32)rc.origin.y * 8;
    rc.size.width = (s32)rc.size.width * 8;
    rc.size.height = (s32)rc.size.height * 8;
    SKTexture* tex = [SKTexture textureWithRect:[GameUtil calcWithUV:rc inTexture:base] inTexture:base];
    SKSpriteNode* sprite = [SKSpriteNode spriteNodeWithTexture:tex];
    sprite.userData = [@{@"GameObject" : self} mutableCopy];
    return sprite;
}
@end
