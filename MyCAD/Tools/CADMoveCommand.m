//
//  CADMoveCommand.m
//  MyCAD
//
//  Created by wubil on 14-4-23.
//  Copyright (c) 2014 Feng. All rights reserved.
//

#import "CADMoveCommand.h"
#import "CADShape.h"
#import "CADCommandManager.h"

@implementation CADMoveCommand

#pragma mark - draw, undo-redo

- (void)draw:(id<DrawingCanvas>)drawingCanvas drawMode:(CADDrawMode)drawMode
{
    for (CADShape *element in drawingCanvas.selection)
    {
#ifdef UseOpenGL
        [element glDraw:drawingCanvas drawMode:drawMode];
#else
        [element draw:drawingCanvas drawMode:drawMode];
#endif
    }
}

#pragma mark - touches events

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event view:(id<DrawingCanvas>)drawingCanvas
{
    if (drawingCanvas.selectionCount == 0)
        return;
    
    [self recordForUndo:drawingCanvas];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event view:(id<DrawingCanvas>)drawingCanvas
{
    UITouch *touch = [touches anyObject];
    CGPoint currentPosition = [drawingCanvas getTouchLocation:touch];
    CGPoint previousPosition = [drawingCanvas getTouchPreviousLocation:touch];
    
    for (CADShape *element in drawingCanvas.selection)
    {
        [element move:previousPosition desPos:currentPosition];
    }
    
    [drawingCanvas setNeedsDisplay];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event view:(id<DrawingCanvas>)drawingCanvas
{
    // make sure the last point is recorded
    [self touchesMoved:touches withEvent:event view:drawingCanvas];
    
    [drawingCanvas redraw]; // redraw
    
    [super touchesEnded:touches withEvent:event view:drawingCanvas];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event view:(id<DrawingCanvas>)drawingCanvas
{
    // make sure the last point is recorded
    [self touchesEnded:touches withEvent:event view:drawingCanvas];
}

@end
