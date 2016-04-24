//
//  DrawingLineTool.m
//  MyCAD
//
//  Created by wubil on 14-4-14.
//  Copyright (c) 2014 Feng. All rights reserved.
//

#import "CADDrawCommand.h"
#import "CADShape.h"
#import "CADCommandManager.h"
#import "CADLine.h"
#import "CADCircle.h"
#import "CADRectangle.h"
#import "CADArc.h"
#import "CADEllipse.h"
#import "CADPath.h"
#import "CADPolyline.h"

@implementation CADDrawCommand

- (id)init
{
    self = [super init];
    if (self != nil)
    {
        //_element = [CADDrawCommand createElement:[CADCommandManager sharedInstance].drawShapeType];
    }
    return self;
}

#pragma mark - draw, undo-redo

- (void)draw:(id<DrawingCanvas>)drawingCanvas drawMode:(CADDrawMode)drawMode
{
    if (_element != NULL)
    {
        #ifdef UseOpenGL
        [_element glDraw:drawingCanvas drawMode:drawMode];
        #else
        [_element draw:drawingCanvas drawMode:drawMode];
        #endif
    }
}

- (void) undo:(id<DrawingCanvas>)drawingCanvas
{
    NSMutableArray *findItems = [[NSMutableArray alloc] init];
    for (CADShape *colneItem in self.listAfter)
    {
        for (CADShape *item in drawingCanvas.shapes)
        {
            if (item.uniqueID == colneItem.uniqueID)
            {
                [findItems addObject:item];
                continue;
            }
        }
    }
    
    [drawingCanvas.shapes removeObjectsInArray:findItems];
    [drawingCanvas redraw];
}

- (void) redo:(id<DrawingCanvas>)drawingCanvas
{
    for (CADShape *item in self.listAfter)
    {
        [drawingCanvas.shapes addObject:item];
    }
    
    [drawingCanvas redraw];
}

+ (CADShape *)createElement:(CADShapeType)shapeType
{
    switch (shapeType) {
        case kShapeCircle:
            return [[CADCircle alloc] init];
            break;
        case kShapePolyline:
            return [[CADPolyline alloc] init];
            break;
        case kShapeLine:
            return [[CADLine alloc] init];
            break;
        case kShapeRectagle:
            return [[CADRectangle alloc] init];
            break;
        case kShapeArc:
            return [[CADArc alloc] init];
            break;
        case kShapeText:
            return [[CADEllipse alloc] init];
            break;
        case kShapePath:
            return [[CADPath alloc] init];
            break;
        default:
            return nil;
            break;
    }
}

#pragma mark - touches events

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event view:(id<DrawingCanvas>)drawingCanvas
{
    UITouch *touch = [touches anyObject];
    CGPoint currentPosition = [drawingCanvas getTouchLocation:touch];
    
    _element = [CADDrawCommand createElement:[CADCommandManager sharedInstance].drawShapeType];
    _element.firstPoint = currentPosition;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event view:(id<DrawingCanvas>)drawingCanvas
{
    UITouch *touch = [touches anyObject];
    CGPoint currentPosition = [drawingCanvas getTouchLocation:touch];
    _element.lastPoint = currentPosition;
    
    [drawingCanvas setNeedsDisplay];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event view:(id<DrawingCanvas>)drawingCanvas
{
    // make sure the last point is recorded
    [self touchesMoved:touches withEvent:event view:drawingCanvas];
    
    // record the new element.
    [drawingCanvas.shapes addObject:_element];
    [drawingCanvas refreshCanvasWithCommand:self];
    
    // UNDO: addCommandToHistory
    [self.listAfter addObject:[_element copy]]; // for operation commands
    [drawingCanvas addCommandToHistory:self];
    
    [self.delegateCommand onCommandEnd];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event view:(id<DrawingCanvas>)drawingCanvas
{
    // make sure the last point is recorded
    [self touchesEnded:touches withEvent:event view:drawingCanvas];
}

@end
