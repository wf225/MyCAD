//
//  CPoint.h
//  MyCAD
//
//  Created by wubil on 14-4-24.
//  Copyright (c) 2014年 Autodesk. All rights reserved.
//

#ifndef MyCAD_CPoint_h
#define MyCAD_CPoint_h

#include <iostream>
#include <vector>
#include <list>
#include <set>
#include <map>
#include <string>
#include <iterator>
#include <algorithm>
#include <functional>
using namespace std;

class CPoint {
    
private:
	int x,y;
    
public:
	//构造与析构函数
	CPoint(double x, double y);
	CPoint(const CPoint& pt);
	~CPoint(){} //NSLog(@"destruction fun called");
	
	//属性
	void setX(int x){this->x=x;}
	void setY(int y){this->y=y;}
	int getX(){return x;}
	int getY(){return y;}
	
    //输出
//	void outPut();
//	friend ostream& operator<<( ostream & out,  CPoint & target);
	
	//运算符重载
	CPoint operator+(CPoint target);
	CPoint operator-(CPoint target);
	void  operator+=(CPoint target);
	void  operator-=(CPoint target);
};

#endif
