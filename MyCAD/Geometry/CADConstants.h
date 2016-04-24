//
//  CADConstants.h
//  MyCAD
//
//  Created by wubil on 14-5-6.
//  Copyright (c) 2014 Feng. All rights reserved.
//

#ifndef MyCAD_CADConstants_h
#define MyCAD_CADConstants_h

typedef enum {
    kShapeArc,
    kShapeCircle,
    kShapeEllipse,
    kShapeLine,
    kShapePath,
    kShapePolyline,
    kShapeRectagle,
    kShapeText
} CADShapeType;

typedef enum {
    kDrawModeNormal,
    kDrawModeSelect,
    kDrawModeDrag,
    kDrawModeErase
    
} CADDrawMode;

typedef enum{
    kLindTypeSolid,
    kLindTypeDash,
    kLindTypeDot,
    kLindTypeDashDot,
    kLindTypeDashDotDot
} CADLindType;

#endif
