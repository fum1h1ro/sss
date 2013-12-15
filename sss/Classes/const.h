// ゲームに関する定数などを定義しておく



//typedef NS_ENUM(s32, kOBJ_PRIORIRY) {
//};
// 表示優先度。数字が大きいほど手前に表示される（実際はCGFloat
typedef NS_ENUM(s32, kOBJ_ZPOSITION) {
    kOBJ_ZPOSITION_BACKGROUND,
    kOBJ_ZPOSITION_NORMAL,
    kOBJ_ZPOSITION_ENEMY_ON_GROUND,
    kOBJ_ZPOSITION_PLAYER_SHOT,
    kOBJ_ZPOSITION_ENEMY_SHOT,
    kOBJ_ZPOSITION_PLAYER,
    kOBJ_ZPOSITION_ENEMY_IN_AIR,
};
// SKPhysicsBodyのcategory, collision, contactTestに使うビット定義（我ながら酷いネーミングセンスだと思うが気にしない
typedef NS_OPTIONS(u32, kHITBIT) {
    kHITBIT_ENEMY_ON_GROUND = (1<<0), // 地上の敵
    kHITBIT_ENEMY_IN_AIR = (1<<1), // 空中の敵
    kHITBIT_ENEMY_SHOT = (1<<2), // 敵の弾
    kHITBIT_PLAYER_SHOT = (1<<3), // 自機の弾
    kHITBIT_PLAYER = (1<<4), // 自機
};

// 自機のパワーレベル
typedef NS_ENUM(s32, kPLAYER_POWER) {
    kPLAYER_POWER_0,
    kPLAYER_POWER_1,
    kPLAYER_POWER_2,
    kPLAYER_POWER_3,
    kPLAYER_POWER_MAX,
};
