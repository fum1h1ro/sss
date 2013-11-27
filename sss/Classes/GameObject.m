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
- (void)updateWithManager:(GameObjectManager*)manager {
    if (_updateFunction) {
        //[self performSelector:_updateFunction withObject:manager]; // この書き方だと、コンパイラの警告が出る（支障はないっぽいが
        //_updateFunctionPtr(self, _updateFunction, manager); // この書き方でもいいはずなのだが、何故かGameObjectが二つ以上になるとアクセス違反
        objc_msgSend(self, _updateFunction, manager);
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
    // nop:継承先でオーバーライドする
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
@end
