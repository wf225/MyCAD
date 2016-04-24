//
//  CADArc.m
//  MyCAD
//
//  Created by wubil on 14-4-19.
//  Copyright (c) 2014 Feng. All rights reserved.
//

#import "CADArc.h"

@implementation CADArc

@synthesize bounds = _bounds;
@synthesize center = _center;
@synthesize radius = _radius;

@synthesize startAngle = _startAngle;
@synthesize endAngle = _endAngle;
@synthesize clockwise = _clockwise;

- (id) initWith:(CGPoint)centerPoint radius:(CGFloat)radius startAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle clockwise:(int)clockwise
{
    if (self = [super init])
    {
        self.center = centerPoint;
        self.radius = radius;
        self.startAngle = startAngle;
        self.endAngle = endAngle;
        self.clockwise = clockwise;
    }
    return self;
}

- (void)draw:(id<DrawingCanvas>)drawingCanvas drawMode:(CADDrawMode)drawMode
{
    self.center = CADPointsCenter(self.firstPoint, self.lastPoint);
    self.radius = (self.lastPoint.x - self.firstPoint.x) / 2.0;
    
    // TODO:
    _startAngle = 0;
    _endAngle = CADPointsAngle(self.firstPoint, self.lastPoint);
    _clockwise = true;
    
    [super drawArc:drawingCanvas drawMode:drawMode center:self.center radius:self.radius startAngle:_startAngle endAngle:_endAngle clockwise:_clockwise];
}

#pragma mark - transform

- (void)move:(CGPoint)basePos desPos:(CGPoint)desPos
{
    CGFloat tx = desPos.x - basePos.x;
    CGFloat ty = desPos.y - basePos.y;
    CGAffineTransform transform = CGAffineTransformMakeTranslation(tx, ty);
    
    self.center = CGPointApplyAffineTransform(self.center, transform);
    
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

- (BOOL)hitTest:(id<DrawingCanvas>)canvas point:(CGPoint)point
{
    bool isInBounds = [self isRectContainsPoint:_bounds p:point];
    if (!isInBounds) {
        return false;
    }
    
    bool isContained = [self isPathContainsPoint:self.path point:point withinDistance:kHitTolerance];
    return isContained;
}

@end
