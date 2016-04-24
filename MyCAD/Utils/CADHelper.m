//
//  GeomHelper.cpp
//  MyCAD
//
//  Created by wubil on 14-4-24.
//  Copyright (c) 2014 Feng. All rights reserved.
//

#import "CADHelper.h"

//CGFloat angleBetweenLines(CGPoint line1Start, CGPoint line1End, CGPoint line2Start, CGPoint line2End) {
//
//    CGFloat a = line1End.x - line1Start.x;
//    CGFloat b = line1End.y - line1Start.y;
//    CGFloat c = line2End.x - line2Start.x;
//    CGFloat d = line2End.y - line2Start.y;
//
//    CGFloat rads = acos(((a*c) + (b*d)) / ((sqrt(a*a + b*b)) * (sqrt(c*c + d*d))));
//
//    return radiansToDegrees(rads);
//}

inline CGPoint CADPointMultiplyScalar(CGPoint point, float value)
{
    return CGPointMake(point.x * value, point.y * value);
}

inline CGColorRef CGColorFromRGB(CGFloat red, CGFloat green, CGFloat blue, CGFloat alpha)
{
//    CGFloat r = (CGFloat) red/255.0;
//    CGFloat g = (CGFloat) green/255.0;
//    CGFloat b = (CGFloat) blue/255.0;
//    CGFloat a = (CGFloat) alpha/255.0;
//    CGFloat components[4] = {r,g,b,a};
    
    CGFloat components[4] = {red, green, blue, alpha};
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGColorRef color = CGColorCreate(colorSpace, components);
    CGColorSpaceRelease(colorSpace);
    
    return color;
}

inline GLKVector4 CGColorToGLKVector(CGColorRef cgColor)
{
    const CGFloat *colorComponents = CGColorGetComponents(cgColor);
    GLKVector4 glColor = GLKVector4Make(colorComponents[0], colorComponents[1], colorComponents[2], colorComponents[3]);
    return glColor;
}

