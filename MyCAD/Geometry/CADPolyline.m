//
//  CADPolyline.m
//  MyCAD
//
//  Created by wubil on 14-4-21.
//  Copyright (c) 2014 Feng. All rights reserved.
//

#import "CADPolyline.h"

@implementation CADPolyline

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
    
    // draw the line
    CGContextMoveToPoint(context, self.firstPoint.x, self.firstPoint.y);
    CGContextAddLineToPoint(context, self.lastPoint.x, self.lastPoint.y);
    CGContextStrokePath(context);
    
    // reset isTouchDraw = true after draw.
    if (!self.isTouchDraw) {
        self.isTouchDraw = true;
    }
}

@end
