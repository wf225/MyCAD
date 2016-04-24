//
//  CPoint.cpp
//  MyCAD
//
//  Created by wubil on 14-4-24.
//  Copyright (c) 2014年 Autodesk. All rights reserved.
//

#include "CPoint.h"

CPoint::CPoint(double x, double y)
{
	this->x=x;
	this->y=y;
}

CPoint::CPoint(const CPoint &pt)
{
	x=pt.x;
	y=pt.y;
}

CPoint CPoint::operator+(CPoint target)
{
	return CPoint(x+target.getX(),y+target.getY());
}

CPoint CPoint::operator-(CPoint target)
{
	return CPoint(x+target.getX(),y+target.getY());
}

void CPoint::operator+=(CPoint target)
{
	x+=target.getX();
	y+=target.getY();
}

void CPoint::operator-=(CPoint target)
{
	x-=target.getX();
	y-=target.getY();
}
