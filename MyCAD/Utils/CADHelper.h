//
//  GeomHelper.h
//  MyCAD
//
//  Created by wubil on 14-4-24.
//  Copyright (c) 2014 Feng. All rights reserved.
//

#ifndef __MyCAD__GeomHelper__
#define __MyCAD__GeomHelper__

#define PI 3.14159265358979323846
#define degreesToRadian(x) (PI * x / 180.0)
#define radiansToDegrees(x) (180.0 * x / PI)

#include <math.h>
#import <GLKit/GLKit.h>

//! return a vector = p1 - p2
CG_INLINE CGPoint
__CADPointMinus(CGPoint p1, CGPoint p2)
{
    return CGPointMake(p1.x - p2.x, p1.y - p2.y);
}
#define CADPointMinus __CADPointMinus

//! return a vector = p1 + p2
CG_INLINE CGPoint
__CADPointPlus(CGPoint p1, CGPoint p2)
{
    return CGPointMake(p1.x + p2.x, p1.y + p2.y);
}
#define CADPointPlus __CADPointPlus

//! Center Between Points
CG_INLINE CGPoint
__CADPointsCenter(CGPoint p1, CGPoint p2)
{
    return CGPointMake((p1.x + p2.x)/2.0, (p1.y + p2.y)/2.0);
}
#define CADPointsCenter __CADPointsCenter

//! Return the intersection angle between p1p2 and X-axis.
CG_INLINE double
__CADPointsAngle(CGPoint p1, CGPoint p2)
{
    double result = atan2(p2.y - p1.y, p2.x - p1.x);
    if (result < 0)
    {
        result += 2 * M_PI;
    }
    return result;
}
#define CADPointsAngle __CADPointsAngle

//! Distance Between Points
CG_INLINE CGFloat
__CADPointsDistance(CGPoint first, CGPoint second)
{
    CGFloat deltaX = second.x - first.x;
    CGFloat deltaY = second.y - first.y;
    return sqrt(deltaX*deltaX + deltaY*deltaY );
}
#define CADPointsDistance __CADPointsDistance

CGPoint CADPointMultiplyScalar(CGPoint point, float value);

CGColorRef CGColorFromRGB(CGFloat red, CGFloat green, CGFloat blue, CGFloat alpha);
GLKVector4 CGColorToGLKVector(CGColorRef cgColor);

#endif /* defined(__MyCAD__GeomHelper__) */

