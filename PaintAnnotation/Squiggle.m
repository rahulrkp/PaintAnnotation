
#import "Squiggle.h"


@implementation Squiggle

// generate set and get methods
@synthesize strokeColor;
@synthesize lineWidth;
@synthesize points;

// initialize the Squiggle object
- (id)init {
  if (self = [super init]){
    points = [[NSMutableArray alloc]init];
    strokeColor = [UIColor blackColor];
  }
  return self;
}


#pragma mark - Public

- (void)addPoint:(CGPoint)point {
  // encode the point in an NSValue so we can put it in an NSArray
  NSValue *value = [NSValue valueWithBytes:&point objCType:@encode(CGPoint)];
  [points addObject:value];
}

@end
