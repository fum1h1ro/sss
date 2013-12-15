//
//  GameButtonNode.h
//  sss
//
//  Created by Kanaya Fumihiro on 2013/12/05.
//  Copyright (c) 2013年 alwaystesting. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface GameButtonNode : SKLabelNode {
}
@property (assign, nonatomic) BOOL cancelled;
@property (assign, nonatomic) BOOL touched;
- (id)initWithFontNamed:(NSString*)fontname;
@end
