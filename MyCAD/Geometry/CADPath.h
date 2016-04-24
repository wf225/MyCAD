//
//  CADSketch.h
//  MyCAD
//
//  Created by wubil on 14-4-19.
//  Copyright (c) 2014 Feng. All rights reserved.
//

#import "CADShape.h"

@interface CADPath : CADShape

//@property (nonatomic, assign) CGPoint startPoint;
//@property (nonatomic, assign) CGPoint endPoint;
@property (nonatomic, readonly) NSMutableArray *points;

// TODO: init with points
- (id) initWith:(NSArray *)points;

@end
