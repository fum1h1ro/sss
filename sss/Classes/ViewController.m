// vim: fenc=utf-8

#import "Common.h"
#import "ViewController.h"
#import "TouchView.h"
#import "GameView.h"
#import "GameScene.h"
#import "VirtualHID.h"
#import "DisplayView.h"

#define kSCREEN_WIDTH_35INCH 320
#define kSCREEN_HEIGHT_35INCH 480
#define kSCREEN_WIDTH_4INCH 320
#define kSCREEN_HEIGHT_4INCH 568


@implementation ViewController
// Storyboardを使わないので、ここで必要なビューを生成する
// このメソッドは、ViewControllerがviewプロパティにアクセスした時に一度だけ呼ばれる
// 自分から呼び出す必要はない
- (void)loadView {
    [self createViews];
}
//
- (void)createViews {
    // 4inchか3.5inchか調べて、GameViewの大きさを調整する
    UIScreen* screen = [UIScreen mainScreen];
    CGRect screenrc = screen.bounds;
    CGFloat longer = fmax(screenrc.size.width, screenrc.size.height);
    if (longer <= kSCREEN_HEIGHT_35INCH) {
        // 4:3
        NS_LOG(@"4:3");
        _isInch4 = NO;
    } else {
        // 約16:9
        NS_LOG(@"16:9");
        _isInch4 = YES;
    }
    self.view = [[TouchView alloc] initWithFrame:screenrc];
    self.view.backgroundColor = [UIColor redColor];
    CGRect gamerc = [self makeGameViewRect];
    self.gameView = [[GameView alloc] initWithFrame:gamerc];
    [self.view addSubview:self.gameView];
#ifdef USE_DISPLAY_VIEW
    DisplayView* dv = [[DisplayView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    [self.view addSubview:dv];
#endif
    // 
    [VirtualHID shared];
    if (_isInch4) {
        CGRect framerc = [self makeFrameViewRect];
        self.frameView = [[UIView alloc] initWithFrame:framerc];
        self.frameView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:self.frameView];
    }
}
// loadViewが完了したあとに呼ばれる
- (void)viewDidLoad {
    [super viewDidLoad];
    // Create and configure the scene.
    GameScene* scene = [[GameScene alloc] init];
    // Present the scene.
    [self.gameView presentScene:scene];
}
// Storyboard使っていなくても、Autolayoutが効いてしまうので、ここで任意のサイズに再設定する
- (void)viewDidLayoutSubviews {
    self.gameView.frame = [self makeGameViewRect];
    if (_isInch4) {
        self.frameView.frame = [self makeFrameViewRect];
    }
}
// GameViewの領域指定を生成する
- (CGRect)makeGameViewRect {
    CGRect rc = [UIScreen mainScreen].bounds;
    if (_isInch4) {
        rc.size.height = kSCREEN_HEIGHT_35INCH;
    }
#ifdef USE_DISPLAY_VIEW
    rc.size.width = 60;
    rc.size.height = 80;
#endif
    return rc;
}
// FrameViewの領域指定を生成する
- (CGRect)makeFrameViewRect {
    CGRect rc = [UIScreen mainScreen].bounds;
    if (_isInch4) {
        rc.origin.y = kSCREEN_HEIGHT_35INCH;
        rc.size.height = kSCREEN_HEIGHT_4INCH - kSCREEN_HEIGHT_35INCH;
    } else {
        rc = CGRectMake(0, 0, 0, 0);
    }
    return rc;
}
//
- (BOOL)shouldAutorotate {
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}
@end
