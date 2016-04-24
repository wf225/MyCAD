//
//  CADZoomCommand.m
//  MyCAD
//
//  Created by wubil on 14-5-3.
//  Copyright (c) 2014 Feng. All rights reserved.
//

#import "CADZoomCommand.h"
#import "CADShape.h"
#import "CADCommandManager.h"
#import "CADLine.h"

@interface CADZoomCommand()
{
    CGPoint _basePostion;
    CGPoint _startPostion;
    
    // zoom
    BOOL pinchZoom;
    CGFloat previousDistance;
    CGFloat zoomFactor;
}
@end

@implementation CADZoomCommand

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
    
    UITouch *touch = [touches anyObject];
    _startPostion = [touch locationInView:drawingCanvas.view];
    
    // get the selected element's center point
    CADShape *element = [drawingCanvas.selection objectAtIndex:0];
    _basePostion = CADPointsCenter(element.bounds.origin,
                                          CGPointMake(element.bounds.origin.x + element.bounds.size.width, element.bounds.origin.y + element.bounds.size.height));
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event view:(id<DrawingCanvas>)drawingCanvas
{
    UITouch *touch = [touches anyObject];
    CGPoint currentPostion = [touch locationInView:drawingCanvas.view];
    CGPoint previousLocation = [touch previousLocationInView:drawingCanvas.view];
    
    double disOld = CADPointsDistance(_basePostion, previousLocation);
    double disNew = CADPointsDistance(_basePostion, currentPostion);
    double scale = disNew / disOld;
    
    for (CADShape *element in drawingCanvas.selection)
    {
        [element scale:_basePostion scaleX:scale scaleY:scale];
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

