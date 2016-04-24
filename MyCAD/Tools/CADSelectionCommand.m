//
//  CADEraseCommand.m
//  MyCAD
//
//  Created by wubil on 14-4-28.
//  Copyright (c) 2014 Feng. All rights reserved.
//

#import "CADSelectionCommand.h"
#import "CADShape.h"

@implementation CADSelectionCommand

- (id)initWithCanvas:(id<DrawingCanvas>)drawingCanvas
{
    if (self = [super init])
    {
        _drawingCanvas = drawingCanvas;
    }
    return self;
}

// refresh the selected items with new color
- (void)redrawSelection:(CADLayer *)pen
{
    [self recordForUndo:_drawingCanvas];
    
    for (CADShape *element in _drawingCanvas.selection)
    {
        element.strokeColor = pen.strokeColor; // refresh  color.
    }
    
    [self recordForRedo:_drawingCanvas];
    [self.delegateCommand onCommandEnd];
    
    //[_drawingCanvas redraw];
    [_drawingCanvas setNeedsDisplay];
}

- (void)eraseSelection
{
    [self recordForUndo:_drawingCanvas];
    
    [_drawingCanvas.shapes removeObjectsInArray:_drawingCanvas.selection];
    
    [self recordForRedo:_drawingCanvas];
    [self.delegateCommand onCommandEnd];
    
    //[_drawingCanvas redraw];
    [_drawingCanvas setNeedsDisplay];
}

- (void)deselect
{
    // don't need to record for undo
    for (CADShape *element in _drawingCanvas.selection)
    {
        element.isSelected = false;
    }
    
    [self.delegateCommand onCommandEnd];
    
    //[_drawingCanvas redraw];
    [_drawingCanvas setNeedsDisplay];
}

@end
