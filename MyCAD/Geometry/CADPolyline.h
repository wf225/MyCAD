//
//  CADPolyline.h
//  MyCAD
//
//  Created by wubil on 14-4-21.
//  Copyright (c) 2014 Feng. All rights reserved.
//

#import "CADShape.h"

@interface CADPolyline : CADShape

// TODO: init with points
- (id) initWith:(CGPoint)start end:(CGPoint)end;


@end
