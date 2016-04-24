//
//  Line2d.cpp
//  MyCAD
//
//  Created by wubil on 14-5-19.
//  Copyright (c) 2014年 Autodesk. All rights reserved.
//

#include "Line2d.h"

bool Line2d::cross2Line(const Line2d& other, Point2d& ptCross)
{
    return mgCross2Line(_start, _end, other._start, other._end, ptCross);
}