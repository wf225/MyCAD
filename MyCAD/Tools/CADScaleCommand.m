//
//  CADScaleCommand.m
//  MyCAD
//
//  Created by wubil on 14-4-23.
//  Copyright (c) 2014 Feng. All rights reserved.
//

#import "CADScaleCommand.h"
#import "CADShape.h"
#import "CADCommandManager.h"
#import "CADLine.h"

@interface CADScaleCommand()
{
    CGPoint _basePostion;
    CGPoint _startPostion;
    CADLine *_tempLine;
}
@end

@implementation CADScaleCommand

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
    
#ifdef UseOpenGL
    [_tempLine glDraw:drawingCanvas drawMode:kDrawModeDrag];
#else
    [_tempLine draw:drawingCanvas drawMode:kDrawModeDrag];
#endif
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
    
    // Draw a temp line
    _tempLine = [[CADLine alloc]initWith:_basePostion end:_startPostion];
    _tempLine.strokeColor = [UIColor lightGrayColor].CGColor;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event view:(id<DrawingCanvas>)drawingCanvas
{
    UITouch *touch = [touches anyObject];
    CGPoint currentPosition = [drawingCanvas getTouchLocation:touch];
    CGPoint previousPosition = [drawingCanvas getTouchPreviousLocation:touch];
    
    double disOld = CADPointsDistance(_basePostion, previousPosition);
    double disNew = CADPointsDistance(_basePostion, currentPosition);
    double scale = disNew / disOld;
    
    for (CADShape *element in drawingCanvas.selection)
    {
        [element scale:_basePostion scaleX:scale scaleY:scale];
    }
    
    // Draw a temp line
    _tempLine.endPoint = currentPosition;
    
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
