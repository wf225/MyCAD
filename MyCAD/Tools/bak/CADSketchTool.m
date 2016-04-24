//
//  DrawingPenTool.m
//  MyCAD
//
//  Created by wubil on 14-4-14.
//  Copyright (c) 2014 Autodesk. All rights reserved.
//

#import "CADSketchTool.h"

@implementation CADSketchTool

+ (id) tool
{
    return [[[self class] alloc] init];
}

- (id)init
{
    self = [super init];
    if (self != nil)
    {
    }
    return self;
}

- (void) activated
{
    
}
- (void) deactivated
{
    
}

#pragma mark - touches events
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event cadCanvas:(CADCanvas *)canvas
{
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event cadCanvas:(CADCanvas *)canvas
{
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event cadCanvas:(CADCanvas *)canvas
{
    
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event cadCanvas:(CADCanvas *)canvas
{
    
}

//@synthesize lineColor = _lineColor;
//@synthesize lineAlpha = _lineAlpha;
//@synthesize lineCapStyle = _lineCapStyle;
//@synthesize lineJoinStyle = _lineJoinStyle;

//- (id)init
//{
//    self = [super init];
//    if (self != nil) {
//        self.lineCapStyle = kCGLineCapRound;
//    }
//    return self;
//}
//
//- (void)setInitialPoint:(CGPoint)firstPoint
//{
//    [self moveToPoint:firstPoint];
//}
//
//- (void)moveFromPoint:(CGPoint)startPoint toPoint:(CGPoint)endPoint
//{
//    [self addQuadCurveToPoint:midPoint(endPoint, startPoint) controlPoint:startPoint];
//}
//
//CGPoint midPoint(CGPoint p1, CGPoint p2)
//{
//    return CGPointMake((p1.x + p2.x) * 0.5, (p1.y + p2.y) * 0.5);
//}
//
//- (void)draw:(CGContextRef)context
//{
//    [self.lineColor setStroke];
//    [self strokeWithBlendMode:kCGBlendModeNormal alpha:self.lineAlpha];
//}
//
//#if !CAD_HAS_ARC
//
//- (void)dealloc
//{
//    self.lineColor = nil;
//    [super dealloc];
//}
//
//#endif

@end
