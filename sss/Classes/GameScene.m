//
//  GameScene.m
//  sss
//
//  Created by Kanaya Fumihiro on 2013/11/11.
//  Copyright (c) 2013年 alwaystesting. All rights reserved.
//

#import "GameScene.h"
#import "ViewController.h"
#import "DisplayView.h"

@implementation GameScene
- (id)init {
    CGSize size = CGSizeMake(320, 480);
    if (self = [super initWithSize:size]) {
        //self.scaleMode = SKSceneScaleModeAspectFill;
        self.scaleMode = SKSceneScaleModeFill;
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:1.0 alpha:1.0];

        SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:@"Spaceship"];
        sprite.size = CGSizeMake(160, 160);
        sprite.position = CGPointMake(160, 240);
        SKAction *action = [SKAction rotateByAngle:M_PI duration:1];
        [sprite runAction:[SKAction repeatActionForever:action]];
        [self addChild:sprite];

    }
    return self;
}
//
- (void)update:(CFTimeInterval)currentTime {
    UIView* view = [self.view snapshotViewAfterScreenUpdates:NO];
    [DisplayView shared].view = view;
    [[DisplayView shared] setNeedsDisplay];
}
#if 0
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    CGSize sz = self.size;
    NSLog(@"%f, %f", sz.width, sz.height);
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        
        SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:@"Spaceship"];
        
        sprite.size = CGSizeMake(160, 160);
        sprite.position = CGPointMake(80, 0);
        
        //SKAction *action = [SKAction rotateByAngle:M_PI duration:10];
        //[sprite runAction:[SKAction repeatActionForever:action]];
        
        [self addChild:sprite];
    }
}
#endif
@end
