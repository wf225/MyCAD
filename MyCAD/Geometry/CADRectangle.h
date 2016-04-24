//
//  CADRectangle.h
//  MyCAD
//
//  Created by wubil on 14-4-18.
//  Copyright (c) 2014 Feng. All rights reserved.
//

#import "CADShape.h"

@interface CADRectangle : CADShape
{
    
}

@property (nonatomic, assign) CGPoint leftTop;
@property (nonatomic, assign) CGPoint rightTop;
@property (nonatomic, assign) CGPoint rightBotton;
@property (nonatomic, assign) CGPoint leftBotton;

- (id) initWith:(CGPoint)leftTop rightTop:(CGPoint)rightTop rightBotton:(CGPoint)rightBotton leftBotton:(CGPoint)leftBotton;

@end
