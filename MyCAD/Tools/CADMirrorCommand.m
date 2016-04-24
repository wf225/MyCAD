//
//  CADMirrorCommand.m
//  MyCAD
//
//  Created by wubil on 14-4-24.
//  Copyright (c) 2014 Feng. All rights reserved.
//

#import "CADMirrorCommand.h"
#import "CADShape.h"
#import "CADCommandManager.h"

@implementation CADMirrorCommand

+ (id) create
{
    return [[[self class] alloc] init];
}

- (id)init
{
    self = [super init];
    if (self != nil)
    {
        
    }
    return self;
}

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

- (void) undo:(id<DrawingCanvas>)drawingCanvas
{
    
}

- (void) redo:(id<DrawingCanvas>)drawingCanvas
{
    
}

#pragma mark - touches events

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event view:(id<DrawingCanvas>)drawingCanvas
{
    //UITouch *touch = [touches anyObject];
    //CGPoint currentLocation = [touch locationInView:drawingCanvas.view];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event view:(id<DrawingCanvas>)drawingCanvas
{
    //UITouch *touch = [touches anyObject];
    //CGPoint currentLocation = [touch locationInView:drawingCanvas.view];
    //CGPoint previousLocation = [touch previousLocationInView:drawingCanvas.view];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event view:(id<DrawingCanvas>)drawingCanvas
{
    // make sure the last point is recorded
    [self touchesMoved:touches withEvent:event view:drawingCanvas];
    
    // set activeCommand = NULL
    [CADCommandManager sharedInstance].activeCommandType = kNullCommand;
    
    // clear the selection
    //[[CADSelection sharedInstance] removeAll];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event view:(id<DrawingCanvas>)drawingCanvas
{
    // make sure the last point is recorded
    [self touchesEnded:touches withEvent:event view:drawingCanvas];
}

@end
