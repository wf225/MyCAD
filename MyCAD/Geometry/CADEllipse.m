//
//  CADEllipse.m
//  MyCAD
//
//  Created by wubil on 14-4-19.
//  Copyright (c) 2014 Feng. All rights reserved.
//

#import "CADEllipse.h"

@implementation CADEllipse

- (id) initWith:(CGPoint)start end:(CGPoint)end
{
    if (self = [super init])
    {
        self.firstPoint = start;
        self.lastPoint = end;
    }
    return self;
}

- (void)draw:(id<DrawingCanvas>)drawingCanvas drawMode:(CADDrawMode)drawMode
{
    [super draw:drawingCanvas drawMode:drawMode];
    CGContextRef context = drawingCanvas.drawContext;
    
    // draw the ellipse
    CGRect rectToFill = CGRectMake(self.firstPoint.x, self.firstPoint.y, self.lastPoint.x - self.firstPoint.x, self.lastPoint.y - self.firstPoint.y);
    CGContextStrokeEllipseInRect(context, rectToFill);
    
    // reset isTouchDraw = true after draw.
    if (!self.isTouchDraw) {
        self.isTouchDraw = true;
    }
}

@end
