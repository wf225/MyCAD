//
//  CADCircle.h
//  MyCAD
//
//  Created by wubil on 14-4-19.
//  Copyright (c) 2014 Feng. All rights reserved.
//

#import "CADShape.h"

@interface CADCircle : CADShape
{
    
}

@property (nonatomic, assign) CGPoint center;
@property (nonatomic, assign) CGFloat radius;

- (id) initWith:(CGPoint)centerPoint radius:(CGFloat)radius;
- (void)drawArc:(id<DrawingCanvas>)drawingCanvas drawMode:(CADDrawMode)drawMode center:(CGPoint)center radius:(CGFloat)radius startAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle clockwise:(int)clockwise;

@end
