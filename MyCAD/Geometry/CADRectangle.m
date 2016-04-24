//
//  CADRectangle.m
//  MyCAD
//
//  Created by wubil on 14-4-18.
//  Copyright (c) 2014 Feng. All rights reserved.
//

#import "CADRectangle.h"

@implementation CADRectangle

@synthesize bounds = _bounds;
@synthesize path = _path;
@synthesize leftTop = _leftTop;
@synthesize rightTop = _rightTop;
@synthesize rightBotton = _rightBotton;
@synthesize leftBotton = _leftBotton;

- (id) initWith:(CGPoint)leftTop rightTop:(CGPoint)rightTop rightBotton:(CGPoint)rightBotton leftBotton:(CGPoint)leftBotton
{
    if (self = [super init])
    {
        self.leftTop = leftTop;
        self.rightTop = rightTop;
        self.rightBotton = rightBotton;
        self.leftBotton = leftBotton;
        
        self.isTouchDraw = true;
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    CADRectangle *newElement = [super copyWithZone:zone];;
    newElement.leftTop = self.leftTop;
    newElement.rightTop = self.rightTop;
    newElement.rightBotton = self.rightBotton;
    newElement.leftBotton = self.leftBotton;
    
    return newElement;
}

#pragma mark - draw

- (void)initDraw
{
    if (self.isTouchDraw)
    {
        CGRect _rect = CGRectMake(self.firstPoint.x, self.firstPoint.y, self.lastPoint.x - self.firstPoint.x, self.lastPoint.y - self.firstPoint.y);
        
        self.leftBotton = _rect.origin;
        self.rightTop = CGPointMake(self.leftBotton.x + _rect.size.width, self.leftBotton.y + _rect.size.height);
        self.leftTop = CGPointMake(self.leftBotton.x, self.leftBotton.y + _rect.size.height);
        self.rightBotton = CGPointMake(self.leftBotton.x + _rect.size.width, self.leftBotton.y);
    }
}

- (void)draw:(id<DrawingCanvas>)drawingCanvas drawMode:(CADDrawMode)drawMode
{
    [super draw:drawingCanvas drawMode:drawMode];
    [self initDraw];
    
    CGContextRef context = drawingCanvas.drawContext;
    
    if (_path != nil) {
        CGPathRelease(_path);
    }
    _path = CGPathCreateMutable();
    
    CGPathMoveToPoint(_path, NULL, self.leftTop.x, self.leftTop.y);
    
    CGPoint points[] = {self.leftTop, self.rightTop, self.rightBotton, self.leftBotton, self.leftTop};
    CGPathAddLines(_path, NULL, points, 5);
    
    CGContextAddPath(context, _path); // add path to context
    CGContextDrawPath(context, kCGPathStroke); // draw path
    
    _bounds = CGPathGetBoundingBox(_path);
}

- (void)glDraw:(id<DrawingCanvas>)drawingCanvas drawMode:(CADDrawMode)drawMode
{
    [super glDraw:drawingCanvas drawMode:drawMode];
    [self initDraw];
    
    CGRect _rect = CGRectMake(self.firstPoint.x, self.firstPoint.y, self.lastPoint.x - self.firstPoint.x, self.lastPoint.y - self.firstPoint.y);
    GLStrokeRect(_rect);
    //NSLog(@"endPoint(%f, %f)", self.lastPoint.x, self.lastPoint.y);
}

#pragma mark - transform

- (void)move:(CGPoint)basePos desPos:(CGPoint)desPos
{
    basePos = CADPointsCenter(self.leftBotton, self.rightTop);
    CGFloat tx = desPos.x - basePos.x;
    CGFloat ty = desPos.y - basePos.y;
    CGAffineTransform transform = CGAffineTransformMakeTranslation(tx, ty);
    
    [self transform:basePos trans:transform];
    
    self.isTouchDraw = false;
}

- (void)rotate:(CGPoint)basePos angle:(double)angle
{
    basePos = CADPointsCenter(self.leftBotton, self.rightTop);
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    transform = CGAffineTransformRotate(transform, angle);
    [self transform:basePos trans:transform];
    
    self.isTouchDraw = false;
}

- (void)scale:(CGPoint)basePos scaleX:(double)scaleX scaleY:(double)scaleY
{
    //basePos = CADPointsCenter(self.leftBotton, self.rightTop);
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    transform = CGAffineTransformScale(transform, scaleX, scaleY);
    [self transform:basePos trans:transform];
    
    self.isTouchDraw = false;
}

- (void)mirror:(CGPoint)pt1 point2:(CGPoint)pt2
{
    // TODO
    self.isTouchDraw = false;
}

- (void)transform:(CGPoint)basePos trans:(CGAffineTransform)transform
{
    CGPoint vecPt1 = CADPointMinus(self.leftBotton, basePos);
    CGPoint vecPt2 = CADPointMinus(self.leftTop, basePos);
    CGPoint vecPt3 = CADPointMinus(self.rightTop, basePos);
    CGPoint vecPt4 = CADPointMinus(self.rightBotton, basePos);
    
    vecPt1 = CGPointApplyAffineTransform(vecPt1, transform);
    vecPt2 = CGPointApplyAffineTransform(vecPt2, transform);
    vecPt3 = CGPointApplyAffineTransform(vecPt3, transform);
    vecPt4 = CGPointApplyAffineTransform(vecPt4, transform);
    
    self.leftBotton = CADPointPlus(basePos, vecPt1);
    self.leftTop = CADPointPlus(basePos, vecPt2);
    self.rightTop = CADPointPlus(basePos, vecPt3);
    self.rightBotton = CADPointPlus(basePos, vecPt4);
}

//- (void)setLeftBotton:(CGPoint)leftBotton
//{
//    _leftBotton = leftBotton;
//    self.firstPoint = leftBotton;
//}
//
//- (void)setRightBotton:(CGPoint)rightBotton
//{
//    _rightBotton = rightBotton;
//    self.lastPoint = rightBotton;
//}

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
