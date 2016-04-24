//
//  CADSketch.m
//  MyCAD
//
//  Created by wubil on 14-4-19.
//  Copyright (c) 2014 Feng. All rights reserved.
//

#import "CADPath.h"

@implementation CADPath

@synthesize path = _path;
@synthesize bounds = _bounds;

- (id)initWith:(NSArray *)points
{
    if (self = [self init])
    {

    }
    return self;
}

- (id)init
{
    if (self = [super init])
    {
        _points = [[NSMutableArray alloc] init];
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    CADPath *newElement = [super copyWithZone:zone];
    [newElement internalSetPoints:self.points];
    return newElement;
}

- (void)internalSetPoints:(NSMutableArray *)points
{
    [_points removeAllObjects];
    
    for (int i = 0; i < points.count - 1; i++)
    {
        CGPoint pt = [[points objectAtIndex:i] CGPointValue];        
        [_points addObject:[NSValue valueWithCGPoint:pt]];
    }
}

#pragma mark - draw

- (void)draw:(id<DrawingCanvas>)drawingCanvas drawMode:(CADDrawMode)drawMode
{
    [super draw:drawingCanvas drawMode:drawMode];
    CGContextRef context = drawingCanvas.drawContext;
    
    if (_path != NULL && drawMode == kDrawModeErase) // release the previous path.
    {
        CGContextAddPath(context, _path);
        CGContextDrawPath(context, kCGPathStroke);
    }
    else
    {
        if (self.isTouchDraw)
        {
            if (_path == NULL)
            {
                _path = CGPathCreateMutable();
                
                CGPathMoveToPoint(_path, NULL, self.firstPoint.x, self.firstPoint.y); // set start point
                
                [self.points addObject:[NSValue valueWithCGPoint:self.self.firstPoint]];
            }
            
            CGPathAddQuadCurveToPoint(_path, NULL, self.lastPoint.x, self.lastPoint.y, self.lastPoint.x, self.lastPoint.y);
            
            [self.points addObject:[NSValue valueWithCGPoint:self.lastPoint]];
        }
        else
        {
            if (_path != NULL) // release the previous path.
            {
                CGPathRelease(_path);
            }
            _path = CGPathCreateMutable();
            
            self.firstPoint = [[self.points objectAtIndex:0] CGPointValue];
            CGPathMoveToPoint(_path, NULL, self.firstPoint.x, self.firstPoint.y); // set start point
            
            for (int i = 1; i < self.points.count - 1; i++)
            {
                self.lastPoint = [[self.points objectAtIndex:i] CGPointValue];
                CGPathAddQuadCurveToPoint(_path, NULL, self.lastPoint.x, self.lastPoint.y, self.lastPoint.x, self.lastPoint.y);
            }
        }
        
        CGContextAddPath(context, _path); // add path to context
        CGContextDrawPath(context, kCGPathStroke); // draw path
        
        _bounds = CGPathGetBoundingBox(_path);
    }
}

#pragma mark - transform

- (void)move:(CGPoint)basePos desPos:(CGPoint)desPos
{
    CGFloat tx = desPos.x - basePos.x;
    CGFloat ty = desPos.y - basePos.y;
    CGAffineTransform transform = CGAffineTransformMakeTranslation(tx, ty);

    for (int i = 0; i < self.points.count - 1; i++)
    {
        CGPoint pt = [[self.points objectAtIndex:i] CGPointValue];
        pt = CGPointApplyAffineTransform(pt, transform);
        
        [self.points replaceObjectAtIndex:i withObject:[NSValue valueWithCGPoint:pt]];
    }

    self.isTouchDraw = false;
}

- (void)rotate:(CGPoint)basePos angle:(double)angle
{
    CGAffineTransform transform = CGAffineTransformIdentity;
    transform = CGAffineTransformRotate(transform, angle);

    basePos = CGPointMake(_bounds.origin.x + _bounds.size.width / 2.0, _bounds.origin.y + _bounds.size.height / 2.0);
    
    for (int i = 0; i < self.points.count - 1; i++)
    {
        CGPoint pt = [[self.points objectAtIndex:i] CGPointValue];
        CGPoint vecPt1 = CGPointMake(pt.x - basePos.x, pt.y - basePos.y);
        vecPt1 = CGPointApplyAffineTransform(vecPt1, transform);
        
        pt = CGPointMake(basePos.x + vecPt1.x, basePos.y + vecPt1.y);
        
        [self.points replaceObjectAtIndex:i withObject:[NSValue valueWithCGPoint:pt]];
    }
    
    self.isTouchDraw = false;
}

- (void)scale:(CGPoint)basePos scaleX:(double)scaleX scaleY:(double)scaleY
{
    CGAffineTransform transform = CGAffineTransformIdentity;
    transform = CGAffineTransformScale(transform, scaleX, scaleY);

    //basePos = CGPointMake(_bounds.origin.x + _bounds.size.width / 2.0, _bounds.origin.y + _bounds.size.height / 2.0);
    
    for (int i = 0; i < self.points.count - 1; i++)
    {
        CGPoint pt = [[self.points objectAtIndex:i] CGPointValue];
        CGPoint vecPt1 = CGPointMake(pt.x - basePos.x, pt.y - basePos.y);
        vecPt1 = CGPointApplyAffineTransform(vecPt1, transform);
        
        pt = CGPointMake(basePos.x + vecPt1.x, basePos.y + vecPt1.y);
        
        [self.points replaceObjectAtIndex:i withObject:[NSValue valueWithCGPoint:pt]];
    }
    
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
