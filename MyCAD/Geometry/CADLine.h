//
//  CADLine.h
//  MyCAD
//
//  Created by wubil on 14-4-18.
//  Copyright (c) 2014 Feng. All rights reserved.
//

#import "CADShape.h"

@interface CADLine : CADShape

@property (nonatomic, assign) CGPoint startPoint;
@property (nonatomic, assign) CGPoint endPoint;

- (id) initWith:(CGPoint)start end:(CGPoint)end;

@end
