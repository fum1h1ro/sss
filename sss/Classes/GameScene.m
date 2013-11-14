//
//  GameScene.m
//  sss
//
//  Created by Kanaya Fumihiro on 2013/11/11.
//  Copyright (c) 2013年 alwaystesting. All rights reserved.
//

#import "ViewController.h"
#import "DisplayView.h"
#import "GameObjectManager.h"
#import "GameScene.h"

@implementation GameScene
- (id)init {
    CGSize size = CGSizeMake(320, 480);
    if (self = [super initWithSize:size]) {
        _objectManager = [[GameObjectManager alloc] initWithScene:self];
        //self.scaleMode = SKSceneScaleModeAspectFill;
        self.scaleMode = SKSceneScaleModeFill;
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:1.0 alpha:1.0];

#if 0
        SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:@"sss"];
        sprite.size = CGSizeMake(160, 160);
        sprite.position = CGPointMake(160, 240);
        SKAction *action = [SKAction rotateByAngle:M_PI duration:1];
        [sprite runAction:[SKAction repeatActionForever:action]];
        [self addChild:sprite];
#endif

        Player* player = [[Player alloc] init];
        [_objectManager addGameObject:player];
    }
    return self;
}
//
- (void)update:(CFTimeInterval)dt {
    [_objectManager updateAllGameObject:dt];
#ifdef USE_DISPLAY_VIEW
    UIView* view = [self.view snapshotViewAfterScreenUpdates:NO];
    [DisplayView shared].view = view;
    [[DisplayView shared] setNeedsDisplay];
#endif
}
#if 0
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    CGSize sz = self.size;
    NS_LOG(@"%f, %f", sz.width, sz.height);
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
