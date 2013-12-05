#import <SpriteKit/SpriteKit.h>
#import "GameCommon.h"

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
    u16 work;
} TMXTile;

typedef NS_OPTIONS(u32, TMXTileOptions) {
    TMXTileOptionsNeedsToCallDelegate = (1<<0),
};

// プロトコル
// 特定のタイルが表示される際に呼び出される
@protocol GameBGNodeDelegate
- (void)activateTile:(TMXTile*)tile position:(CGPoint)pos;
@end

@interface GameBGNode : SKNode {
    NSMutableData* _tmxbin;
    u32 _screen_xcount, _screen_ycount; // 表示用タイルを並べる大きさ
    const TMXHeader* _header;
    TMXTile* _tiles;
    SKTexture* _texture;
    u32 _npattern, _pattern_column, _pattern_row;
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
- (void)updateNodes;
- (SKTexture*)getPattern:(s16)pid;
@end

