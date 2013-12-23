#import "ScenePause.h"
#import "SceneTitle.h"

@implementation ScenePause
- (instancetype)init {
    if (self = [super init]) {
        _titleButton = [[GameButtonNode alloc] initWithFontNamed:@"Chalkduster"];
        _titleButton.text = @"RETURN TO TITLE";
        _titleButton.zPosition = 100;
        _titleButton.position = CGPointMake(0, 100);
        _titleButton.fontSize = 16;
        _resumeButton = [[GameButtonNode alloc] initWithFontNamed:@"Chalkduster"];
        _resumeButton.text = @"RESUME";
        _resumeButton.zPosition = 100;
        _resumeButton.position = CGPointMake(0, 0);
        _resumeButton.fontSize = 48;
        _wait = 0.0f;
        [self addChild:_titleButton];
        [self addChild:_resumeButton];
    }
    return self;
}
- (void)beforeObjectUpdate {
    GameView* gameview = _objectManager.scene.gameView;
    // 背景に直前のシーンのスクリーンショットを用いる
    if (_bg == nil) {
        SKTexture* lasttexture = gameview.lastTexture;
        _bg = [SKSpriteNode spriteNodeWithTexture:gameview.lastTexture];
        _bg.color = [SKColor grayColor];
        _bg.colorBlendFactor = 1.0f;
        [self addChild:_bg];
    }
    if (_titleButton.touched) {
        if (!_showAlert) {
            // 突然のUIAlertView!!
            // 本来はゲーム独自のUIの方が格好いいでしょう
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Really?" message:@"Do you want to return to TITLE?" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
            [alert show];
            _showAlert = YES;
        }
    } else
    if (_resumeButton.touched) {
        if (_wait == 0.0f) {
            [_resumeButton runAction:[SKAction group:@[[SKAction scaleTo:2.0f duration:0.5f], [SKAction fadeAlphaTo:0.0f duration:0.5f]]]];
        }
        if (_wait < 0.5f) {
            _wait += [GameTimer shared].deltaTime;
        } else
        if (!_poped) {
            [gameview popScene:[SKTransition doorsOpenHorizontalWithDuration:0.5f]];
            _poped = YES;
            // どうも、presentView:系で新規ビューを表示させても、少しの間旧ビューも動いてしまうみたいなので、
            // フラグで明示的に一回しか呼ばないようにする
        }
    }
}
//
- (void)alertView:(UIAlertView*)view clickedButtonAtIndex:(NSInteger)buttonidx {
    NS_LOG(@"%d", buttonidx);
    if (buttonidx == 0) {
        [_titleButton reset];
        _showAlert = NO;
    } else
    if (buttonidx == 1) {
        GameView* gameview = _objectManager.scene.gameView;
        [gameview presentScene:[[SceneTitle alloc] init] transition:[SKTransition doorsCloseHorizontalWithDuration:0.5f]];
    }
}
@end
