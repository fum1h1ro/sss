// vim: fenc=utf-8
#import <SpriteKit/SpriteKit.h>

// SKViewを継承したGame表示用ビュー
// なんか追加あるかなと思って継承させたけど、そのままになってしまった
@interface GameView : SKView
+ (GameView*)shared;
@end
