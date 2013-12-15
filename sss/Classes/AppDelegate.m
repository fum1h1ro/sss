//
//  AppDelegate.m
//  sss
//
//  Created by Kanaya Fumihiro on 2013/11/08.
//  Copyright (c) 2013年 alwaystesting. All rights reserved.
//

#import "AppDelegate.h"
#import "Profile.h"
@implementation AppDelegate

- (BOOL)application:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)launchOptions {
    // Storyboardを使わないので、ここでUIWindowとViewControllerを生成しておく
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.viewcontroller = [[ViewController alloc] initWithNibName:nil bundle:nil];
    self.window.rootViewController = self.viewcontroller;
    [self.window makeKeyAndVisible];
    [Profile shared];
#if 0
    self.speechSynthesizer = [[AVSpeechSynthesizer alloc] init];
    AVSpeechUtterance* ut = [AVSpeechUtterance speechUtteranceWithString:@"get ready"];
    [self.speechSynthesizer speakUtterance:ut];
#endif
    return YES;
}
// ホームボタン二回押しで、アプリ選択画面になると呼ばれる
- (void)applicationWillResignActive:(UIApplication*)application {
    NS_LOG(@"%s", __PRETTY_FUNCTION__);
    [_viewcontroller.gameView applicationWillResignActive];
}
// 他のアプリに遷移した時点で呼ばれる
- (void)applicationDidEnterBackground:(UIApplication*)application {
    NS_LOG(@"%s", __PRETTY_FUNCTION__);
    [_viewcontroller.gameView applicationDidEnterBackground];
}
// 再度選択された時に呼ばれる（applicationDidBecomeActive:より先に呼ばれる
- (void)applicationWillEnterForeground:(UIApplication*)application {
    NS_LOG(@"%s", __PRETTY_FUNCTION__);
    [_viewcontroller.gameView applicationWillEnterForeground];
}
// 再度選択された時に呼ばれる（applicationWillEnterForeground:より後に呼ばれる
- (void)applicationDidBecomeActive:(UIApplication*)application {
    NS_LOG(@"%s", __PRETTY_FUNCTION__);
    [_viewcontroller.gameView applicationDidBecomeActive];
}
//
- (void)applicationWillTerminate:(UIApplication*)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    NS_LOG(@"%s", __PRETTY_FUNCTION__);
}
//
+ (id)readJSON:(NSString*)name {
    NSString* path = [[NSBundle mainBundle] pathForResource:name ofType:@"json"];
    NSData* data = [NSData dataWithContentsOfFile:path];
    id r = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    return r;
}
@end
