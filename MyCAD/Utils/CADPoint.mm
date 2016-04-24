//
//  CADPoint.m
//  MyCAD
//
//  Created by wubil on 14-4-24.
//  Copyright (c) 2014 Feng. All rights reserved.
//

#import "CADPoint.h"

@implementation CADPoint
@synthesize x=_x;
@synthesize y=_y;


- (id)init:(CGFloat)x y:(CGFloat)y
{
    if (self = [super init]) {
        self.x = x;
        self.y = y;
    }
    return self;
}

- (id)initWith:(CGPoint)pt
{
    if (self = [self init:pt.x y:pt.y]) {

    }
    return self;
}

- (double)Distance:(CGPoint)p2
{
    double tx = self.x - p2.x;
    double ty = self.y - p2.y;
    return sqrt(tx*tx + ty*ty);
}

- (CGPoint)Plus:(CGPoint)p2
{
    return CGPointMake(self.x + p2.x, self.y + p2.y);
}

- (CGPoint)Minus:(CGPoint)p2
{
    return CGPointMake(self.x - p2.x, self.y - p2.y);
}

- (CGPoint)PlusOffset:(CGFloat)offset
{
    return CGPointMake(self.x + offset, self.y + offset);
}

- (CGPoint)RotateBy:(CGPoint)center angle:(CGFloat)angle
{
    CGPoint p = [self Minus:center];
    CGPoint q = CGPointMake(
                      p.x * cos(angle) - p.y * sin(angle),
                      p.x * sin(angle) + p.y * cos(angle)
                      );
    
    CADPoint *cadPt = [[CADPoint alloc]initWith:q];
    return [cadPt Plus:center];
}

- (CGPoint)Scale:(CGFloat)scaleFactor
{
    return CGPointMake(self.x * scaleFactor, self.y * scaleFactor);
}

@end
