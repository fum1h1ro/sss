//
//  GameBGNode.m
//  sss
//
//  Created by Kanaya Fumihiro on 2013/11/27.
//  Copyright (c) 2013年 alwaystesting. All rights reserved.
//

#import "GameBGNode.h"


@implementation GameBGNode
//
- (id)initWithTMXFile:(NSString*)path size:(CGSize)sz {
    if (self = [super init]) {
        //NS_LOG(@"%@", path);
        _screenSize = sz;
        _tmxbin = [NSMutableData dataWithContentsOfFile:path];
        if (_tmxbin) {
            [self parseTMX];
            _screen_xcount = (sz.width / _header->tile_width) + 1;
            _screen_ycount = (sz.height / _header->tile_height) + 1;
            [self makePatterns];
            [self makeNodes];
        }
    }
    return self;
}
//
- (void)dealloc {
    if (_nodes) {
        u32 sz = _screen_xcount * _screen_ycount;
        for (u32 i = 0; i < sz; ++i) {
            _nodes[i] = nil;
        }
        free(_nodes);
        _nodes = nil;
    }
    if (_patterns) {
        for (u32 i = 0; i < _npattern; ++i) {
            _patterns[i] = nil;
        }
        free(_patterns);
        _patterns = nil;
    }
}
//
- (void)parseTMX {
    _header = [_tmxbin mutableBytes];
    _tiles = (TMXTile*)(_header + 1);
    _texture = [SKTexture textureWithImageNamed:[NSString stringWithUTF8String:_header->texturename]];
    CGSize sz = _texture.size;
    _pattern_column = (u32)sz.width / _header->tile_width;
    _pattern_row = (u32)sz.height / _header->tile_height;
    _npattern = _pattern_column * _pattern_row;
}
// 背景データに使用されているタイル番号から必要なSKTextureを作っておく
- (void)makePatterns {
    // SKTexture*の配列を確保
    _patterns = (__strong SKTexture**)calloc(sizeof(SKTexture*), _npattern);
    const u16 mw = _header->map_width;
    const u16 mh = _header->map_height;
    for (u16 y = 0; y < mh; ++y) {
        for (u16 x = 0; x < mw; ++x) {
            const TMXTile* t = (_tiles + mw * y + x);
            //NS_LOG(@"%d", t->id);
            if (t->id >= 0 && _patterns[t->id] == nil) {
                [self getPattern:t->id];
            }
        }
    }
}
// パターンIDからSKTexture*を取得する。ない場合は新たに作る
- (SKTexture*)getPattern:(s16)pid {
    if (_patterns[pid] == nil) {
        CGSize sz = _texture.size;
        const f32 tw = _header->tile_width / sz.width;
        const f32 th = _header->tile_height / sz.height;
        const f32 height = 1.0f;
        s16 px = pid % _pattern_column;
        s16 py = pid / _pattern_column;
        CGRect uvrc = CGRectMake(px * tw, py * th, tw, th);
        uvrc.origin.y = height - uvrc.origin.y - th;
        _patterns[pid] = [SKTexture textureWithRect:uvrc inTexture:_texture];
    }
    return _patterns[pid];
}
//
- (void)makeNodes {
    u32 nodecount = _screen_xcount * _screen_ycount;
    // SKSpriteNode*の配列を確保
    _nodes = (__strong SKSpriteNode**)calloc(sizeof(SKSpriteNode*), nodecount);
    CGSize sz = CGSizeMake(_header->tile_width, _header->tile_height);
    for (u32 i = 0; i < nodecount; ++i) {
        _nodes[i] = [SKSpriteNode spriteNodeWithColor:[SKColor clearColor] size:sz];
    }
    const u16 sw = _screen_xcount;
    const u16 sh = _screen_ycount;
    const CGFloat ox = -(_screenSize.width * 0.5f);
    const CGFloat oy = -(_screenSize.height * 0.5f);
    for (u16 y = 0; y < sh; ++y) {
        for (u16 x = 0; x < sw; ++x) {
            u16 idx = y * sw + x;
            SKSpriteNode* node = _nodes[idx];
            node.anchorPoint = CGPointMake(0, 0); // 原点を左下に
            node.position = CGPointMake(ox + x * sz.width, oy + y * sz.height);
            [self addChild:node];
        }
    }
    self.position = CGPointMake(80, 120);
}
//
- (void)updateNodes {
    CGSize tilesz = CGSizeMake(_header->tile_width, _header->tile_height);
    CGPoint origin = CGPointMake(_targetPosition.x - _screenSize.width * 0.5f, _targetPosition.y - _screenSize.height * 0.5f); // 左下原点

    s32 srcx = origin.x / tilesz.width;
    s32 srcy = origin.y / tilesz.height;
    f32 modx = fmod(origin.x, tilesz.width);
    f32 mody = fmod(origin.y, tilesz.height);

    [self updateNodesPatternFromX:srcx andY:srcy];
    self.position = CGPointMake(_nodeCenter.x - modx, _nodeCenter.y - mody);
}
//
- (void)updateNodesPatternFromX:(s32)srcx andY:(s32)srcy {
    s32 mapw = _header->map_width;
    s32 maph = _header->map_height;
    for (s32 y = 0; y < _screen_ycount; ++y) {
        s32 sy = srcy + y;
        for (s32 x = 0; x < _screen_xcount; ++x) {
            s32 sx = srcx + x;
            u16 idx = y * _screen_xcount + x;
            SKSpriteNode* node = _nodes[idx];
            const TMXTile* t = (_tiles + mapw * sy + sx);
            if (sy < 0 || maph <= sy || sx < 0 || mapw <= sx || t->id < 0) {
                // 範囲外が何もセットされていない
                node.texture = nil;
                node.color = [SKColor clearColor];
            } else {
                if ((t->work & TMXTileOptionsNeedsToCallDelegate) && _delegate) {
                    const s16 oldid = t->id;
                    [_delegate activateTile:(TMXTile*)t];
                    if (oldid != t->id) [self getPattern:t->id];
                }
                node.texture = _patterns[t->id];
                node.color = [SKColor whiteColor];
            }
        }
    }
}
@end
