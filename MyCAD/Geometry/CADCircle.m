//
//  CADCircle.m
//  MyCAD
//
//  Created by wubil on 14-4-19.
//  Copyright (c) 2014 Feng. All rights reserved.
//

#import "CADCircle.h"

@implementation CADCircle

@synthesize bounds = _bounds;
@synthesize center = _center;
@synthesize radius = _radius;
@synthesize path = _path;

- (id) initWith:(CGPoint)centerPoint radius:(CGFloat)radius
{
    if (self = [super init])
    {
        self.center = centerPoint;
        self.radius = radius;
        self.isTouchDraw = false;
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    CADCircle *newElement = [super copyWithZone:zone];
    newElement.center = self.center;
    newElement.radius = self.radius;
    
    return newElement;
}

#pragma mark - draw

- (void)initDraw
{
    if (self.isTouchDraw)
    {
        self.center = self.firstPoint;
        self.radius = CADPointsDistance(self.center, self.lastPoint);
    }
}

- (void)draw:(id<DrawingCanvas>)drawingCanvas drawMode:(CADDrawMode)drawMode
{
    [self initDraw];
    
    [self drawArc:drawingCanvas drawMode:drawMode center:self.center radius:self.radius startAngle:0 endAngle:M_PI*2 clockwise:false];
}

- (void)glDraw:(id<DrawingCanvas>)drawingCanvas drawMode:(CADDrawMode)drawMode
{
    [super glDraw:drawingCanvas drawMode:drawMode];
    [self initDraw];
    
    GLStrokeCircle(self.center, self.radius, 80);
    //NSLog(@"Circle-endPoint(%f, %f)", self.lastPoint.x, self.lastPoint.y);
}

- (void)drawArc:(id<DrawingCanvas>)drawingCanvas drawMode:(CADDrawMode)drawMode center:(CGPoint)center radius:(CGFloat)radius startAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle clockwise:(int)clockwise
{
    [super draw:drawingCanvas drawMode:drawMode];
    CGContextRef context = drawingCanvas.drawContext;
    
    if (_path != nil) {
        CGPathRelease(_path);
    }
    _path = CGPathCreateMutable();
    
    CGPathMoveToPoint(_path, NULL, center.x + radius, center.y); // set start point
    
    CGPathAddArc(_path, NULL, center.x, center.y, radius, startAngle, endAngle, clockwise); // draw line
    
    CGContextAddPath(context, _path); // add path to context
    CGContextDrawPath(context, kCGPathStroke); // draw path
    
    _bounds = CGPathGetBoundingBox(_path);
}

#pragma mark - transform

- (void)move:(CGPoint)basePos desPos:(CGPoint)desPos
{
    CGFloat tx = desPos.x - basePos.x;
    CGFloat ty = desPos.y - basePos.y;
    CGAffineTransform transform = CGAffineTransformMakeTranslation(tx, ty);
    
    self.center = CGPointApplyAffineTransform(self.center, transform);
    NSLog(@"Circle-center(%f, %f)", self.center.x, self.center.y);
    
    self.isTouchDraw = false;
}

- (void)rotate:(CGPoint)basePos angle:(double)angle
{
//    basePos = CADPointsCenter(self.firstPoint, self.lastPoint);
//    CGPoint vecPt1 = CGPointMake(self.firstPoint.x - basePos.x, self.firstPoint.y - basePos.y);
//    CGPoint vecPt2 = CGPointMake(self.lastPoint.x - basePos.x, self.lastPoint.y - basePos.y);
//    
//    CGAffineTransform transform = CGAffineTransformIdentity;
//    transform = CGAffineTransformRotate(transform, angle);
//    
//    vecPt1 = CGPointApplyAffineTransform(vecPt1, transform);
//    vecPt2 = CGPointApplyAffineTransform(vecPt2, transform);
//    
//    self.firstPoint = CGPointMake(basePos.x + vecPt1.x, basePos.y + vecPt1.y);
//    self.lastPoint = CGPointMake(basePos.x + vecPt2.x, basePos.y + vecPt2.y);
    
    self.isTouchDraw = false;
}

- (void)scale:(CGPoint)basePos scaleX:(double)scaleX scaleY:(double)scaleY
{
    self.radius *= scaleX;
    
    self.isTouchDraw = false;
}

- (void)mirror:(CGPoint)pt1 point2:(CGPoint)pt2
{
    // TODO
    self.isTouchDraw = false;
}

#pragma mark - hit

- (CGRect) bounds
{
    return CGRectMake(self.center.x - self.radius, self.center.y - self.radius, self.radius * 2, self.radius * 2);
}

- (BOOL)hitTest:(id<DrawingCanvas>)canvas point:(CGPoint)point
{
    bool isInBounds = [self isRectContainsPoint:self.bounds p:point];
    if (!isInBounds) {
        return false;
    }
    
    //bool isContained = [self isPathContainsPoint:self.path point:point withinDistance:kHitTolerance];
    bool isPathContained = abs(CADPointsDistance(self.center, point) - self.radius) < kHitTolerance / canvas.scaleFactor;
    return isPathContained;
}

@end
