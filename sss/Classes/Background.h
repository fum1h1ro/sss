@class Player;

@interface Background : GameObject {
    CGFloat _centerX;
}
@property (strong, nonatomic) GameBGNode* bgNode;
@property (strong, nonatomic) SKNode* originNode;
@property (assign, nonatomic) CGPoint targetPosition;
@property (assign, nonatomic) f32 speed;
@property (assign, nonatomic) CGFloat offsetX;
- (id)initWithTMXFile:(NSString*)path size:(CGSize)sz;



@end
