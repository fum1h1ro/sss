//
//  ViewController.m
//  sss
//
//  Created by Kanaya Fumihiro on 2013/11/08.
//  Copyright (c) 2013年 alwaystesting. All rights reserved.
//

#import "ViewController.h"
#import "MyScene.h"
#import "GameView.h"

@implementation ViewController
- (void)loadView {
    // Storyboardを使わないので、ここで必要なビューを生成する
    // このメソッドは、ViewControllerがviewプロパティにアクセスした時に一度だけ呼ばれる
    UIScreen* screen = [UIScreen mainScreen];
    CGRect rc = screen.bounds;
    self.view = [[GameView alloc] initWithFrame:rc];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Configure the view.
    SKView * skView = (SKView *)self.view;
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
    skView.userInteractionEnabled = YES;
    // Create and configure the scene.
    SKScene * scene = [MyScene sceneWithSize:skView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    
    // Present the scene.
    [skView presentScene:scene];
}

- (BOOL)shouldAutorotate
{
    return YES;
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
