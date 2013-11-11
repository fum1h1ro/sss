// vim: fenc=utf-8

#import "ViewController.h"
#import "MyScene.h"
#import "GameView.h"
#import "GameScene.h"

@implementation ViewController
// Storyboardを使わないので、ここで必要なビューを生成する
// このメソッドは、ViewControllerがviewプロパティにアクセスした時に一度だけ呼ばれる
// 自分から呼び出す必要はない
- (void)loadView {
    UIScreen* screen = [UIScreen mainScreen];
    CGRect rc = screen.bounds;
    self.view = [[GameView alloc] initWithFrame:rc];
}
// loadViewが完了したあとに呼ばれる
- (void)viewDidLoad {
    [super viewDidLoad];
    // Configure the view.
    GameView* view = (GameView*)self.view;
#ifdef DEBUG
    view.showsFPS = YES;
    view.showsDrawCount = YES;
    view.showsNodeCount = YES;
#endif
    view.userInteractionEnabled = YES;
    view.contentScaleFactor = [UIScreen mainScreen].scale;
    // Create and configure the scene.
    GameScene* scene = [[GameScene alloc] init];
    
    // Present the scene.
    [view presentScene:scene];
}
//
- (void)viewDidLayoutSubviews {
    GameView* view = (GameView*)self.view;
    [view layoutSubviewsLocal];
}
//
- (BOOL)shouldAutorotate {
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}
@end
