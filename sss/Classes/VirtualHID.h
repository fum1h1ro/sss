//
//  VirtualHID.h
//  sss
//
//  Created by Kanaya Fumihiro on 2013/11/09.
//  Copyright (c) 2013”N alwaystesting. All rights reserved.
//

#import <Foundation/Foundation.h>
// 
@interface VirtualHID : NSObject {
}
@property (readonly, nonatomic) CGPoint touchPos;
@property (readonly, nonatomic) BOOL isTouch;
+ (VirtualHID*)shared;
- (void)touchesBegan:(NSSet*)touches;
- (void)touchesEnded:(NSSet*)touches;
- (void)touchesMoved:(NSSet*)touches;
- (void)update;
@end
