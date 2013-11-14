// vim: fenc=utf-8
#import "TouchView.h"
#import "ViewController.h"

@implementation TouchView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

//
- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event {
    //[[VirtualHID shared] touchesBegan:touches];
    [super touchesBegan:touches withEvent:event];
}
- (void)touchesCancelled:(NSSet*)touches withEvent:(UIEvent*)event {
    NS_LOG(@"CANCEL");
}
- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event {
    //[[VirtualHID shared] touchesEnded:touches];
    [super touchesEnded:touches withEvent:event];
}
- (void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event {
    //[[VirtualHID shared] touchesMoved:touches];
    [super touchesMoved:touches withEvent:event];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
