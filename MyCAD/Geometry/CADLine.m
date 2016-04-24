//
//  CADLine.m
//  MyCAD
//
//  Created by wubil on 14-4-18.
//  Copyright (c) 2014 Feng. All rights reserved.
//

#import "CADLine.h"

@implementation CADLine

@synthesize bounds = _bounds;
@synthesize path = _path;

- (id) initWith:(CGPoint)start end:(CGPoint)end
{
    if (self = [super init])
    {
        self.startPoint = start;
        self.endPoint = end;
        
        self.isTouchDraw = false;
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    CADLine *newElement = [super copyWithZone:zone];
    newElement.startPoint = self.startPoint;
    newElement.endPoint = self.endPoint;
    return newElement;
}

#pragma mark - draw

- (void)initDraw
{
    if (self.isTouchDraw)
    {
        self.startPoint = self.firstPoint;
        self.endPoint = self.lastPoint;
    }
}

- (void)draw:(id<DrawingCanvas>)drawingCanvas drawMode:(CADDrawMode)drawMode
{
    [super draw:drawingCanvas drawMode:drawMode];
    [self initDraw];
    
    // Quartz2D draw
    CGContextRef context = drawingCanvas.drawContext;
    
    if (_path != nil) {
        CGPathRelease(_path);
    }
    _path = CGPathCreateMutable();
    
    CGPathMoveToPoint(_path, NULL, self.startPoint.x, self.startPoint.y); // set start point
    CGPathAddLineToPoint(_path, NULL, self.endPoint.x, self.endPoint.y); // draw line
    
    CGContextAddPath(context, _path); // add path to context
    CGContextDrawPath(context, kCGPathStroke); // draw path
    
    _bounds = CGPathGetBoundingBox(_path);
    
    // Draw text
    //        CGContextSelectFont(context, "Helvetica", 30.0, kCGEncodingMacRoman);
    //        CGContextSetTextDrawingMode(context, kCGTextFill);
    //
    //        NSString *dimStart = [NSString stringWithFormat:@"(%f %f)", self.startPoint.x, self.startPoint.y];
    //        CGContextShowTextAtPoint(context, self.startPoint.x, self.startPoint.y, [dimStart UTF8String], dimStart.length);
    //
    //        NSString *dimEnd = [NSString stringWithFormat:@"(%f %f)", self.endPoint.x, self.endPoint.y];
    //        CGContextShowTextAtPoint(context, self.endPoint.x, self.endPoint.y, [dimEnd UTF8String], dimEnd.length);
    
    
    // draw the bounds
    //        CGPathMoveToPoint(_path, NULL, _bounds.origin.x, _bounds.origin.y);
    //        CGPathAddRect(_path, NULL, _bounds);
    //        CGContextAddPath(context, _path);
    //        CGContextDrawPath(context, kCGPathStroke); // draw path
}

- (void)glDraw:(id<DrawingCanvas>)drawingCanvas drawMode:(CADDrawMode)drawMode
{
    [super glDraw:drawingCanvas drawMode:drawMode];
    [self initDraw];
    
    GLStrokeLine(self.startPoint, self.endPoint);
    //NSLog(@"endPoint(%f, %f)", self.lastPoint.x, self.lastPoint.y);
}

#pragma mark - transform

- (void)move:(CGPoint)basePos desPos:(CGPoint)desPos
{
    CGFloat tx = desPos.x - basePos.x;
    CGFloat ty = desPos.y - basePos.y;
    CGAffineTransform transform = CGAffineTransformMakeTranslation(tx, ty);
    
    self.startPoint = CGPointApplyAffineTransform(self.startPoint, transform);
    self.endPoint = CGPointApplyAffineTransform(self.endPoint, transform);
    
    self.isTouchDraw = false;
}

- (void)rotate:(CGPoint)basePos angle:(double)angle
{
    basePos = CADPointsCenter(self.startPoint, self.endPoint);
    CGPoint vecPt1 = CGPointMake(self.startPoint.x - basePos.x, self.startPoint.y - basePos.y);
    CGPoint vecPt2 = CGPointMake(self.endPoint.x - basePos.x, self.endPoint.y - basePos.y);
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    transform = CGAffineTransformRotate(transform, angle);
    
    vecPt1 = CGPointApplyAffineTransform(vecPt1, transform);
    vecPt2 = CGPointApplyAffineTransform(vecPt2, transform);
    
    self.startPoint = CGPointMake(basePos.x + vecPt1.x, basePos.y + vecPt1.y);
    self.endPoint = CGPointMake(basePos.x + vecPt2.x, basePos.y + vecPt2.y);
    
    // The below also worked well
//    CADPoint *start = [[CADPoint alloc]initWith:self.startPoint];
//    self.startPoint = [start RotateBy:basePos angle:angle];
//    
//    CADPoint *end = [[CADPoint alloc]initWith:self.endPoint];
//    self.endPoint = [end RotateBy:basePos angle:angle];
    
    self.isTouchDraw = false;
}

- (void)scale:(CGPoint)basePos scaleX:(double)scaleX scaleY:(double)scaleY
{
    //basePos = CADPointsCenter(self.startPoint, self.endPoint);
    CGPoint vecPt1 = CGPointMake(self.startPoint.x - basePos.x, self.startPoint.y - basePos.y);
    CGPoint vecPt2 = CGPointMake(self.endPoint.x - basePos.x, self.endPoint.y - basePos.y);
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    transform = CGAffineTransformScale(transform, scaleX, scaleY);
    
    vecPt1 = CGPointApplyAffineTransform(vecPt1, transform);
    vecPt2 = CGPointApplyAffineTransform(vecPt2, transform);
    
    self.startPoint = CGPointMake(basePos.x + vecPt1.x, basePos.y + vecPt1.y);
    self.endPoint = CGPointMake(basePos.x + vecPt2.x, basePos.y + vecPt2.y);
    
    self.isTouchDraw = false;
}

- (void)mirror:(CGPoint)pt1 point2:(CGPoint)pt2
{
    // TODO
    self.isTouchDraw = false;
}

#pragma mark - bound, hitTest

//- (CGRect) bounds
//{
//    return CGRectMake(self.center.x - self.radius, self.center.y - self.radius, self.radius * 2, self.radius * 2);
//}

- (BOOL)hitTest:(id<DrawingCanvas>)canvas point:(CGPoint)point
{
    bool isInBounds = [self isRectContainsPoint:_bounds p:point]; //CGRectContainsPoint(_bounds, point);
    if (!isInBounds) {
        return false;
    }
    
    bool isPathContained = [self isPathContainsPoint:self.path point:point withinDistance:kHitTolerance];
    return isPathContained;
}

@end
