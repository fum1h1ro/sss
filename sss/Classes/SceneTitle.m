#import "SceneTitle.h"
#import "SceneMain.h"

@implementation SceneTitle
- (instancetype)init {
    if (self = [super init]) {
        _resumeButton = [[GameButtonNode alloc] initWithFontNamed:@"Chalkduster"];
        _resumeButton.text = @"START";
        _resumeButton.zPosition = 100;
        _wait = 0.0f;
        [self addChild:_resumeButton];
    }
    return self;
}
- (void)beforeObjectUpdate {
    GameView* gameview = _objectManager.scene.gameView;
    if (_bg == nil) {
        SKTexture* lasttexture = gameview.lastTexture;
        NS_LOG(@"%f %f", lasttexture.size.width, lasttexture.size.height);
        _bg = [SKSpriteNode spriteNodeWithTexture:gameview.lastTexture];
        _bg.color = [SKColor grayColor];
        _bg.colorBlendFactor = 1.0f;
        [self addChild:_bg];
    }
    if (_resumeButton.touched) {
        if (_wait == 0.0f) {
            [_resumeButton runAction:[SKAction group:@[[SKAction scaleTo:0.0f duration:0.5f], [SKAction fadeAlphaTo:0.0f duration:0.5f]]]];
        }
        if (_wait < 0.5f) {
            _wait += [GameTimer shared].deltaTime;
        } else
        if (!_poped) {
            [gameview presentScene:[[SceneMain alloc] init] transition:[SKTransition doorsOpenHorizontalWithDuration:0.75f]];
            _poped = YES;
        }
    }
}

@end
