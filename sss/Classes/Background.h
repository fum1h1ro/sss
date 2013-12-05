
@interface Background : GameObject<GameBGNodeDelegate>
@property (strong, nonatomic) GameBGNode* bgNode;
@property (strong, nonatomic) SKNode* originNode;
@property (assign, nonatomic) CGPoint targetPosition;
- (id)initWithTMXFile:(NSString*)path size:(CGSize)sz;



@end
