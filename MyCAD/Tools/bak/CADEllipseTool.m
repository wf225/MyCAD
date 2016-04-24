//
//  DrawingEllipseTool.m
//  MyCAD
//
//  Created by wubil on 14-4-14.
//  Copyright (c) 2014 Autodesk. All rights reserved.
//

#import "CADEllipseTool.h"
#import "CADRectangle.h"
#import "CADEllipse.h"

@interface CADEllipseTool ()
{
    CADEllipse *_ellipse;
}

@end

#pragma mark -

@implementation CADEllipseTool

+ (id) tool
{
    return [[[self class] alloc] init];
}

- (id)init
{
    self = [super init];
    if (self != nil)
    {
        _ellipse = [[CADEllipse alloc] init];
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
    UITouch *touch = [touches anyObject];
    CGPoint currentLocation = [touch locationInView:(UIView *)canvas];
    
    _ellipse.firstPoint = currentLocation;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event cadCanvas:(CADCanvas *)canvas
{
    UITouch *touch = [touches anyObject];
    CGPoint currentLocation = [touch locationInView:(UIView *)canvas];
    //CGPoint previousLocation = [touch previousLocationInView:(UIView *)canvas];
    
    _ellipse.lastPoint = currentLocation;

}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event cadCanvas:(CADCanvas *)canvas
{
    // make sure the last point is recorded
    [self touchesMoved:touches withEvent:event cadCanvas:canvas];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event cadCanvas:(CADCanvas *)canvas
{
    // make sure the last point is recorded
    [self touchesEnded:touches withEvent:event cadCanvas:canvas];
}

- (void)draw:(CGContextRef)context
{
    [_ellipse draw:context drawMode:kDrawModeNormal];
}


//- (void)setInitialPoint:(CGPoint)firstPoint
//{
//    self.firstPoint = firstPoint;
//}
//
//- (void)moveFromPoint:(CGPoint)startPoint toPoint:(CGPoint)endPoint
//{
//    self.lastPoint = endPoint;
//}
//
//- (void)draw:(CGContextRef)context
//{
//    //CGContextRef context = UIGraphicsGetCurrentContext();
//    
//    // set the properties
//    CGContextSetAlpha(context, self.lineAlpha);
//    
//    // draw the ellipse
//    CGRect rectToFill = CGRectMake(self.firstPoint.x, self.firstPoint.y, self.lastPoint.x - self.firstPoint.x, self.lastPoint.y - self.firstPoint.y);
//    if (self.fill) {
//        CGContextSetFillColorWithColor(context, self.lineColor.CGColor);
//        CGContextFillEllipseInRect(context, rectToFill);
//        
//    } else {
//        CGContextSetStrokeColorWithColor(context, self.lineColor.CGColor);
//        CGContextSetLineWidth(context, self.lineWidth);
//        CGContextStrokeEllipseInRect(context, rectToFill);
//    }
//}

@end
