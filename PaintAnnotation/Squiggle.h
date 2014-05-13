
#import <Foundation/Foundation.h>


@interface Squiggle : NSObject {
  
  NSMutableArray *points;	// the points that make up the Squiggle
  UIColor *strokeColor;	// the color of this Squiggle
  float lineWidth;	//	the line width for this Squiggle
  
  // end instance variable declartion
}

// declare strokeColor, lineWidth and points as properties
@property (retain) UIColor* strokeColor;
@property (assign) float lineWidth;
@property (nonatomic, readonly) NSMutableArray *points;

- (void)addPoint:(CGPoint)point;	// adds a new point to the Suiggle
@end
