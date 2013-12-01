#import "GameView.h"
#import "GameScene.h"
#import "GameObject.h"
#import "GameObjectManager.h"
#import "GameHID.h"
#import "GameUtil.h"

// ゲームオブジェクトを管理するクラスです
// 基本的には、ゲームオブジェクトを配列として複数持ち、
// 毎フレーム全てのゲームオブジェクトに対して更新を行います
// 同時に、ゲームオブジェクトから自分を削除して欲しいという要求があれば、
// 削除します（Objective-Cの仕様上、ここで必ずしもデストラクタが呼ばれるわけではない）
@implementation GameObjectManager
//
- (id)initWithScene:(GameScene*)scene {
    if (self = [super init]) {
        self.scene = scene;
        self.active = [NSMutableArray arrayWithCapacity:1024];
        self.newbie = [NSMutableArray arrayWithCapacity:1024];
        self.remove = [NSMutableIndexSet indexSet];
    }
    return self;
}
// ゲームオブジェクトを追加する
// ここで追加されたゲームオブジェクトは、次のフレーム（updateAllGameObject:）から処理されるようになる
- (void)addGameObject:(GameObject*)obj {
    [_newbie addObject:obj];
    obj.manager = self;
    [obj resetAsNewbie]; // リセットされる
}
// 全てのゲームオブジェクトを更新する
- (void)updateAllGameObject:(NSTimeInterval)dt {
    // 新たに入ってくるものが居るなら、ここで追加する
    if ([_newbie count] > 0) {
        [_active addObjectsFromArray:_newbie];
        [_newbie removeAllObjects];
        // @todo ソートする
    }
    u32 idx = 0;
    for (GameObject* obj in _active) {
        [obj updateWithManager:self];
        // 削除要求が来ていたら、削除リストに追加しておく
        if (obj.isRemove) {
            [obj willRemove];
            obj.manager = nil;
            [_remove addIndex:idx];
        }
        ++idx;
    }
    // 削除予約されたものがあるなら
    if ([_remove count] > 0) {
        [_active removeObjectsAtIndexes:_remove];
        [_remove removeAllIndexes];
    }
}
// アクション計算後に呼ばれる（あまり必要でない気がする。アクション使わないので）
- (void)didEvaluateActions {
    for (GameObject* obj in _active) {
        if ([obj respondsToSelector:@selector(didEvaluateActions)])
            [obj performSelector:@selector(didEvaluateActions)];
    }
}
// 物理シミュ終了時に呼ばれる
- (void)didSimulatePhysics {
    for (GameObject* obj in _active) {
        if ([obj respondsToSelector:@selector(didSimulatePhysics)])
            [obj performSelector:@selector(didSimulatePhysics)];
    }
}
@end





