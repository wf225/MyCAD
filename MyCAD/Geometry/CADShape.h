//
//  CADElement.h
//  MyCAD
//
//  Created by wubil on 14-4-18.
//  Copyright (c) 2014 Feng. All rights reserved.
//

//#if __has_feature(objc_arc)
//#define CAD_HAS_ARC 1
//#define CAD_RETAIN(exp) (exp)
//#define CAD_RELEASE(exp)
//#define CAD_AUTORELEASE(exp) (exp)
//#else
//#define CAD_HAS_ARC 0
//#define CAD_RETAIN(exp) [(exp) retain]
//#define CAD_RELEASE(exp) [(exp) release]
//#define CAD_AUTORELEASE(exp) [(exp) autorelease]
//#endif

static float kDefaultLineColor[] = {0, 0, 0, 0}; //black
//#define kDefaultLineColor       [UIColor blackColor].CGColor
#define kDefaultLineWidth       2.0f
#define kDefaultLineAlpha       1.0f
#define kHitTolerance            20.0f

#import <Foundation/Foundation.h>
#import "CADHelper.h"
#import "GLDrawUtils.h"

#import "CADLayer.h"
#import "DrawingCanvas.h"
#import "CADConstants.h"

@interface CADShape : NSObject<NSCopying> //NSCoding,

@property (nonatomic, copy) NSString* uniqueID;

@property (nonatomic, readonly) CGMutablePathRef path; // record the path for histest.
@property (nonatomic, readonly) CGRect bounds;
//@property (nonatomic, weak) CADLayer *layer;

// Style:
@property (nonatomic, assign) float alpha; //Values can range from 0.0 (transparent) to 1.0 (opaque).
@property CGColorRef strokeColor;
@property CGColorRef fillColor;
@property CGColorRef highlightColor;
@property CGFloat lineWidth;

@property CGLineCap lineCapStyle;
@property CGLineJoin lineJoinStyle;
@property BOOL isSelected;

// Positio
@property BOOL isTouchDraw;
@property CGPoint firstPoint;
@property CGPoint lastPoint;

// Draw
// Quartz2D draw
- (void)draw:(id<DrawingCanvas>)drawingCanvas drawMode:(CADDrawMode)drawMode;
// OpenGL draw
- (void)glDraw:(id<DrawingCanvas>)drawingCanvas drawMode:(CADDrawMode)drawMode;

// Operation
- (void)move:(CGPoint)basePos desPos:(CGPoint)desPos;
- (void)rotate:(CGPoint)basePos angle:(double)angle;
- (void)scale:(CGPoint)basePos scaleX:(double)scaleX scaleY:(double)scaleY;
- (void)mirror:(CGPoint)pt1 point2:(CGPoint)pt2;

// hit test
- (BOOL)hitTest:(id<DrawingCanvas>)canvas point:(CGPoint)point;
- (BOOL)isRectContainsPoint:(CGRect)rect p:(CGPoint)p;
- (BOOL)isPathContainsPoint:(CGPathRef)path point:(CGPoint)p withinDistance:(CGFloat)distance;

// grip
- (int)HandleCount;
- (CGPoint)GetHandle:(int)handleNumber;
- (int)MakeHitTest:(CGPoint)point;
- (void)MoveHandleTo:(Point)point handleNumber:(int)handleNumber;
   
@end

