//
//  GameScene.h
//  sss
//
//  Created by Kanaya Fumihiro on 2013/11/11.
//  Copyright (c) 2013年 alwaystesting. All rights reserved.
//

#import "GameObjectManager.h"

@interface GameScene : SKScene
@property (strong, nonatomic) GameObjectManager* objectManager;
+ (GameScene*)scene;
@end
