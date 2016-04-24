
#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>

//#import "WDBezierSegment.h"

void GLFillRect(CGRect rect);
void GLStrokeRect(CGRect rect);
void GLFillCircle(CGPoint center, float radius, int sides);
void GLStrokeCircle(CGPoint center, float radius, int sides);
void GLStrokeLine(CGPoint a, CGPoint b);

void WDGLFillDiamond(CGPoint center, float dimension);

//void WDGLFlattenBezierSegment(WDBezierSegment seg, GLfloat **vertices, NSUInteger *size, NSUInteger *index);
//void WDGLRenderBezierSegment(WDBezierSegment seg);
void WDGLRenderCGPathRef(CGPathRef pathRef);

void WDGLDrawLineStrip(GLfloat *vertices, NSUInteger count);
