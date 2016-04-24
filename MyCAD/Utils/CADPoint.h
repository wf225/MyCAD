//
//  CADPoint.h
//  MyCAD
//
//  Created by wubil on 14-4-24.
//  Copyright (c) 2014 Feng. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import <math.h>
#import "CADHelper.h"

@interface CADPoint : NSObject

@property (nonatomic, assign) double x;
@property (nonatomic, assign) double y;

- (id)init:(CGFloat)x y:(CGFloat)y;
- (id)initWith:(CGPoint)pt;

- (double)Distance:(CGPoint)p2;

- (CGPoint)Plus:(CGPoint)p2;
- (CGPoint)Minus:(CGPoint)p2;
- (CGPoint)PlusOffset:(CGFloat)offset;

- (CGPoint)RotateBy:(CGPoint)center angle:(CGFloat)angle;
- (CGPoint)Scale:(CGFloat)scaleFactor;

@end
