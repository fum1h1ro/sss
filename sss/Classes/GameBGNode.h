#import <SpriteKit/SpriteKit.h>
#import "GameCommon.h"

// データのヘッダ
typedef struct {
    char id[4]; // 識別子
    u32 version; // バージョン
    u16 map_width, map_height; // マップのタイルが並んでいる数
    u16 tile_width, tile_height; // タイルの大きさ
    char texturename[15+1]; // テクスチャ名
} TMXHeader;
// タイルデータ
typedef struct {
    s16 id;
    u16 work;
} TMXTile;

@interface GameBGNode : SKNode {
    NSData* _tmxbin;
    u32 _screen_width, _screen_height; // 表示用タイルを並べる大きさ
    const TMXHeader* _header;
    const TMXTile* _tiles;
    SKTexture* _texture;
    u32 _npattern, _pattern_column, _pattern_row;
    __strong SKSpriteNode** _nodes;
    __strong SKTexture** _patterns;
}
- (id)initWithTMXFile:(NSString*)path;
@property (assign, nonatomic) CGPoint targetPosition;
@property (assign, nonatomic) CGPoint nodeCenter;
- (void)updateNodes;
@end
