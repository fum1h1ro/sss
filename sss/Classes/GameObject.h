//
//  GameObject.h
//  sss
//
//  Created by Kanaya Fumihiro on 2013/11/20.
//  Copyright (c) 2013年 alwaystesting. All rights reserved.
//

#import <Foundation/Foundation.h>
@class GameObjectManager;

#define kGameObjectDefaultPriority 1000
@interface GameObject : NSObject {
    GameObjectManager* _manager;
    CGPoint _position;
    CGFloat _rotation;
    NSTimeInterval _lifeTime;
}
@property (strong, nonatomic) GameObjectManager* manager;
@property (assign, nonatomic) CGPoint position;
@property (assign, nonatomic) CGFloat rotation;
@property (assign, readonly, nonatomic) NSTimeInterval lifeTime;
@property (assign, nonatomic) s32 priority;
@property (assign, readonly, nonatomic) BOOL isUpdateFirst;
@property (assign, readonly, nonatomic) BOOL isRemove;
@property (assign, nonatomic) SEL updateFunction;
- (void)resetAsNewbie;
- (void)updateWithManager:(GameObjectManager*)manager;
- (void)removeReservation;
- (BOOL)isVisible:(SKNode*)node;
- (void)willRemove;
- (void)didBeginContact:(SKPhysicsContact*)contact with:(GameObject*)other;
- (void)didEndContact:(SKPhysicsContact*)contact with:(GameObject*)other;
- (void)applyPosture:(SKNode*)node;
@end

