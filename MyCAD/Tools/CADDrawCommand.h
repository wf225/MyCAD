//
//  DrawingLineTool.h
//  MyCAD
//
//  Created by wubil on 14-4-14.
//  Copyright (c) 2014 Feng. All rights reserved.
//

#import "CADCommandBase.h"
@class CADShape;

@interface CADDrawCommand : CADCommandBase //NSObject<CADCommand>
{
    CADShape *_element;
}

//@property (nonatomic, strong)NSMutableArray *listBefore;
//@property (nonatomic, strong)NSMutableArray *listAfter;

+ (CADShape *)createElement:(CADShapeType)shapeType;

@end
