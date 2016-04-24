//
//  Line2d.h
//  MyCAD
//
//  Created by wubil on 14-5-19.
//  Copyright (c) 2014年 Autodesk. All rights reserved.
//

#ifndef __MyCAD__Line2d__
#define __MyCAD__Line2d__

#include "geomLineSpatial.h"

//! 线段图形类
/*! \ingroup GEOM_SHAPE
 */
class Line2d
{
private:
    Point2d   _start;    //!< Start point
    Point2d   _end;      //!< End point
    
public:
    //! 构造
    Line2d()
    {
    }
    
    ~Line2d()
    {
    }
    
    //! 构造
    Line2d(Point2d startPt, Point2d endPt)
    {
        _start = startPt;
        _end = endPt;
    }
    
    const Point2d& startPoint() const { return _start; }
    
    const Point2d& endPoint() const { return _end; }
    
    void setStartPoint(const Point2d& startPt){ _start = startPt; }
    
    void setEndPoint(const Point2d& startPt){ _end = startPt; }
    
    Point2d center(){ return (_start + _end)/2; }
    
    //! 求两条线段的交点
    bool cross2Line(const Line2d& other, Point2d& ptCross);

};

#endif /* defined(__MyCAD__Line2d__) */
