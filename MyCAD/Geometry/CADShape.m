//
//  CADElement.m
//  MyCAD
//
//  Created by wubil on 14-4-18.
//  Copyright (c) 2014 Feng. All rights reserved.
//

#import "CADShape.h"
#import "CADLayerManager.h"
#import <GLKit/GLKit.h>

@implementation CADShape

@synthesize uniqueID = _uniqueID;
@synthesize path = _path;
@synthesize bounds = _bounds;
//@synthesize layer = _layer;

@synthesize alpha = _alpha;
@synthesize strokeColor = _strokeColor;
@synthesize fillColor = _fillColor;
@synthesize lineWidth = _lineWidth;
@synthesize lineCapStyle = _lineCapStyle;
@synthesize lineJoinStyle = _lineJoinStyle;

@synthesize firstPoint = _firstPoint;
@synthesize lastPoint = _lastPoint;
@synthesize isSelected = _isSelected;

- (id) init
{
    if (self = [super init])
    {
        CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
        CFStringRef newUniqueIDString = CFUUIDCreateString(kCFAllocatorDefault, uuid);
        self.uniqueID = (__bridge NSString *)newUniqueIDString;
        self.isTouchDraw = true;
        
        // TODO: support Layer
        //[[CADLayerManager sharedInstance].activeLayer addObject:self];
        
        self.fillColor = [CADLayerManager sharedInstance].drawingPen.fillColor;
        self.strokeColor = [CADLayerManager sharedInstance].drawingPen.strokeColor;
        self.lineWidth = [CADLayerManager sharedInstance].drawingPen.lineWidth;
        self.alpha = 1.0;
        
        self.lineCapStyle = kCGLineCapRound;
        self.lineJoinStyle = kCGLineJoinMiter;
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    CADShape *newElement = [[[self class] allocWithZone:zone] init];
    newElement.isTouchDraw = false;
    newElement.uniqueID = self.uniqueID;
    return newElement;
}

- (void)setAlpha:(float)alpha
{
    _alpha = alpha;
    
    const CGFloat *colorComponents = CGColorGetComponents(self.strokeColor);
    self.strokeColor = CGColorFromRGB(colorComponents[0], colorComponents[1], colorComponents[2], alpha);
}

#pragma mark - draw

// Quartz2D draw
- (void)draw:(id<DrawingCanvas>)drawingCanvas drawMode:(CADDrawMode)drawMode
{
    CGContextRef context = drawingCanvas.drawContext;
    
    // set the line properties
    CGContextSetStrokeColorWithColor(context, self.strokeColor);
    CGContextSetLineCap(context, self.lineCapStyle);
    CGContextSetLineWidth(context, self.lineWidth);
    
    if (drawMode == kDrawModeSelect || drawMode == kDrawModeDrag)
    {
        CGFloat dashPhase = 0.0;
        CGContextSetLineDash(context, dashPhase, patterns[1].pattern, patterns[1].count); // dash line
    }
    else if (drawMode == kDrawModeErase)
    {
        CGContextSetAlpha(context, 0.0); // set alpha = 0.0 (transparent)
    }
    else //if (drawMode == kDrawModeNormal)
    {
        CGContextSetAlpha(context, self.alpha);
        
        CGFloat dashPhase = 0.0;
        CGContextSetLineDash(context, dashPhase, patterns[0].pattern, patterns[0].count); // solid line
    }
}

// OpenGL draw
- (void)glDraw:(id<DrawingCanvas>)drawingCanvas drawMode:(CADDrawMode)drawMode
{
    //
    if (drawMode == kDrawModeSelect || drawMode == kDrawModeDrag)
    {
        self.lineWidth = 4;
    }
    else
    {
        self.lineWidth = 2;
    }
    
    // color
    drawingCanvas.effect.useConstantColor = YES;
    drawingCanvas.effect.constantColor = CGColorToGLKVector(self.strokeColor);
    [drawingCanvas.effect prepareToDraw];
    
    // line width
    glLineWidth(self.lineWidth);
}

#pragma mark - transform

- (void)move:(CGPoint)basePos desPos:(CGPoint)desPos
{
    // virtual function
}

- (void)rotate:(CGPoint)basePos angle:(double)angle
{
    // virtual function
}

- (void)scale:(CGPoint)basePos scaleX:(double)scaleX scaleY:(double)scaleY
{
    // virtual function
}

- (void)mirror:(CGPoint)pt1 point2:(CGPoint)pt2
{
    // virtual function
}

//- (id)clone
//{
//    CADElement *element = [[CADElement alloc]init];
//    element.strokeColor = self.strokeColor;
//    element.lineWidth = self.lineWidth;
//    element.lineCapStyle = self.lineCapStyle;
//    element.lineJoinStyle = self.lineJoinStyle;
//    
//    element.firstPoint = self.firstPoint;
//    element.lastPoint = self.lastPoint;
//    
//    return element;
//}

#pragma mark - pick

- (BOOL)hitTest:(id<DrawingCanvas>)canvas point:(CGPoint)point
{
    // The below should be implemented in subclass.
    
//    bool isInBounds = CGRectContainsPoint(_bounds, point); //[self isRectContainsPoint:_bounds p:point];
//    if (!isInBounds) {
//        return false;
//    }
//    
//    bool isContained = [self isPathContainsPoint:point withinDistance:kHitTolerance ofPath:self.path];
//    
//    return isContained;
    
    return false;
}

//- (CGRect) bounds
//{
//    return CGPathGetBoundingBox(_path);
//}

- (BOOL)isRectContainsPoint:(CGRect)rect p:(CGPoint)p
{
    CGPoint leftBottom = CGPointMake(rect.origin.x - kHitTolerance, rect.origin.y - kHitTolerance);
    CGPoint rightTop = CGPointMake(rect.origin.x + rect.size.width + kHitTolerance, rect.origin.y + rect.size.height + kHitTolerance);
    if (leftBottom.x < p.x && p.x < rightTop.x
        && leftBottom.y < p.y && p.y < rightTop.y)
    {
        return true;
    }
    return false;
}

- (BOOL)isPathContainsPoint:(CGPathRef)path point:(CGPoint)p withinDistance:(CGFloat)distance
{
    CGPathRef hitPath = CGPathCreateCopyByStrokingPath(path, NULL, distance*2, kCGLineCapRound, kCGLineJoinRound, 0);
    BOOL isWithinDistance = CGPathContainsPoint(hitPath, NULL, p, false);
    CGPathRelease(hitPath);
    return isWithinDistance;
}

@end
