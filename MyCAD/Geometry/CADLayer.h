//
//  CADLayer.h
//  MyCAD
//
//  Created by wubil on 14-4-18.
//  Copyright (c) 2014 Feng. All rights reserved.
//

#import <Foundation/Foundation.h>

// Each dash entry is a run-length in the current coordinate system
// The concept is first you determine how many points in the current system you need to fill.
// Then you start consuming that many pixels in the dash pattern for each element of the pattern.
// So for example, if you have a dash pattern of {10, 10}, then you will draw 10 points, then skip 10 points, and repeat.
// As another example if your dash pattern is {10, 20, 30}, then you draw 10 points, skip 20 points, draw 30 points,
// skip 10 points, draw 20 points, skip 30 points, and repeat.
// The dash phase factors into this by stating how many points into the dash pattern to skip.
// So given a dash pattern of {10, 10} with a phase of 5, you would draw 5 points (since phase plus 5 yields 10 points),
// then skip 10, draw 10, skip 10, draw 10, etc.
typedef struct {
	CGFloat pattern[5];
	size_t count;
} Pattern;

static Pattern patterns[] = {
    {{1}, 0}, // To get back to solid line
	{{5.0, 5.0}, 2},
	{{10.0, 20.0, 10.0}, 3},
	{{10.0, 20.0, 30.0}, 3},
	{{10.0, 20.0, 10.0, 30.0}, 4},
	{{10.0, 10.0, 20.0, 20.0}, 4},
	{{10.0, 10.0, 20.0, 30.0, 50.0}, 5},
};

@interface CADLayer : NSObject // CAShapeLayer //<NSCoding, NSCopying>

@property (nonatomic, readonly) NSMutableArray *elements;

// Layer attribute:
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) BOOL hidden;
@property (nonatomic, assign) BOOL locked;

// Style:
@property float alpha; //Values can range from 0.0 (transparent) to 1.0 (opaque).
@property CGColorRef strokeColor;
@property CGColorRef fillColor;
@property CGColorRef highlightColor;
@property CGFloat lineWidth;

- (id) initWithName:(NSString *)layerName;

//- (void) addObject:(id)obj;
//- (void) addObjects:(NSArray *)objects;
//- (void) removeObject:(id)obj;

@end
