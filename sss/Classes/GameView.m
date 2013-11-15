// vim: fenc=utf-8
#import "GameView.h"

static GameView* instance = nil;

@implementation GameView
//
+ (GameView*)shared {
    return instance;
}
//
- (id)initWithFrame:(CGRect)frame {
    if (instance) return nil;
    if (self = [super initWithFrame:frame]) {
        instance = self;
#ifdef DEBUG
        self.backgroundColor = [UIColor greenColor];
        self.showsFPS = YES;
        self.showsDrawCount = YES;
        self.showsNodeCount = YES;
#endif
        self.contentScaleFactor = 1.0f;
    }
    return self;
}
@end
