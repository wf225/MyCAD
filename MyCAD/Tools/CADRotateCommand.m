//
//  CADRotateCommand.m
//  MyCAD
//
//  Created by wubil on 14-4-21.
//  Copyright (c) 2014 Feng. All rights reserved.
//

#import "CADRotateCommand.h"
#import "CADShape.h"
#import "CADCommandManager.h"
#import "CADLine.h"

@interface CADRotateCommand()
{
    CGPoint _startPostion;
    CGPoint _basePostion;
    CADLine *_tempLine;
}
@end

@implementation CADRotateCommand

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
    _basePostion = CGPointMake(element.bounds.origin.x + element.bounds.size.width / 2.0, element.bounds.origin.y + element.bounds.size.height / 2.0);
    
    // draw a temp line
    _tempLine = [[CADLine alloc]initWith:_basePostion end:_startPostion];
    _tempLine.strokeColor = [UIColor lightGrayColor].CGColor;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event view:(id<DrawingCanvas>)drawingCanvas
{
    UITouch *touch = [touches anyObject];
    CGPoint currentPosition = [drawingCanvas getTouchLocation:touch];
    CGPoint previousPosition = [drawingCanvas getTouchPreviousLocation:touch];
    
    double startAngle = CADPointsAngle(_basePostion, previousPosition);
    double currentAngle = CADPointsAngle(_basePostion, currentPosition);
    double tAngle = currentAngle - startAngle;
    if (tAngle < 0)
    {
        tAngle += M_PI * 2;
    }
    //NSLog(@"startAngle=%f, currentAngle=%f, tAngle=%f", startAngle, currentAngle, tAngle);
    
    for (CADShape *element in drawingCanvas.selection)
    {
        [element rotate:_basePostion angle:tAngle];
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
    
    _tempLine = nil;
    [super touchesEnded:touches withEvent:event view:drawingCanvas];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event view:(id<DrawingCanvas>)drawingCanvas
{
    // make sure the last point is recorded
    [self touchesEnded:touches withEvent:event view:drawingCanvas];
}

@end
