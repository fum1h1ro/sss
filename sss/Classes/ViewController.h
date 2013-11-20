// vim: fenc=utf-8

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
#import "Game.h"

@interface ViewController : UIViewController
@property (assign, nonatomic) BOOL isInch4;
@property (strong, nonatomic) GameView* gameView;
@property (strong, nonatomic) UIView* frameView;
@end
