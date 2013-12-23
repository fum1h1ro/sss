#import "Game.h"
#import "const.h"
#import "Profile.h"
#import "SceneMain.h"

@interface Item : GameObject {
    CGFloat _center;
    CGFloat _time;
    BOOL _visible;
}
@end


@interface ItemPowerUp : Item
- (instancetype)initWithPos:(CGPoint)pos;
@end

@interface ItemBonus : Item
- (instancetype)initWithPos:(CGPoint)pos;
@end
