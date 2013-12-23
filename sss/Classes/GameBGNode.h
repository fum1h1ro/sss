#import <SpriteKit/SpriteKit.h>
#import "GameCommon.h"

#pragma pack(push, 1)
// データのヘッダ
typedef struct {
    char id[4]; // 識別子
    u32 version; // バージョン
    u16 map_xcount, map_ycount; // マップのタイルが並んでいる数
    u16 tile_width, tile_height; // タイルの大きさ
    char texturename[15+1]; // テクスチャ名
} TMXHeader;
// タイルデータ
typedef struct {
    s16 id;
    u8 attr;
    u8 type;
} TMXTile;
#pragma pack(pop)

typedef NS_OPTIONS(u8, TMXTileOptions) {
    TMXTileOptionsNeedsToCallDelegate = (1<<0),
    TMXTileOptionsHadMadeObject = (1<<1),
};
@class GameBGNode;

// プロトコル
// 特定のタイルが表示される際に呼び出される
@protocol GameBGNodeDelegate
- (void)gameBGNode:(GameBGNode*)node activateTile:(TMXTile*)tile position:(CGPoint)pos tileX:(s32)x andY:(s32)y;
@end

@interface GameBGNode : SKNode {
    NSMutableData* _tmxbin;
    u32 _screen_xcount, _screen_ycount; // 表示用タイルを並べる大きさ
    const TMXHeader* _header;
    TMXTile* _tiles;
    SKTexture* _texture;
    u32 _npattern, _patternColumn, _patternRow;
    __strong SKSpriteNode** _nodes;
    __strong SKTexture** _patterns;
}
- (id)initWithTMXFile:(NSString*)path size:(CGSize)sz;
@property (assign, nonatomic) CGPoint targetPosition;
@property (assign, nonatomic) CGPoint nodeCenter;
@property (assign, readonly, nonatomic) CGSize screenSize;
@property (assign, readonly, nonatomic) CGSize mapSize;
@property (assign, readonly, nonatomic) CGSize tileSize;
@property (assign, nonatomic) id<GameBGNodeDelegate> delegate;
@property (assign, nonatomic) u32 patternColumn;
@property (assign, nonatomic) u32 patternRow;
- (void)updateNodes;
- (SKTexture*)getPattern:(s16)pid;
- (SKTexture*)getPattern:(s16)pid withSize:(CGSize)size;
- (TMXTile*)getTileX:(s32)x andY:(s32)y;
@end

