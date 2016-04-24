//
//  CADCommandBase.m
//  MyCAD
//
//  Created by wubil on 14-4-29.
//  Copyright (c) 2014 Feng. All rights reserved.
//

#import "CADCommandBase.h"
#import "CADShape.h"
#import "CADCommandManager.h"

@implementation CADCommandBase

@synthesize listAfter = _listAfter;
@synthesize listBefore = _listBefore;

+ (id) create
{
    return [[[self class] alloc] init];
}

- (id)init
{
    self = [super init];
    if (self != nil)
    {        
        self.listBefore = [[NSMutableArray alloc] init];
        self.listAfter = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc
{
    [self.listBefore removeAllObjects];
    [self.listAfter removeAllObjects];
    self.listAfter = nil;
    self.listBefore = nil;
}

#pragma mark - draw, undo-redo

- (void)draw:(id<DrawingCanvas>)drawingCanvas drawMode:(CADDrawMode)drawMode
{
//    for (CADShape *element in drawingCanvas.selection)
//    {
//#ifdef UseOpenGL
//        [element glDraw:drawingCanvas drawMode:drawMode];
//#else
//        [element draw:drawingCanvas drawMode:drawMode];
//#endif
//    }
}

- (void) undo:(id<DrawingCanvas>)drawingCanvas
{
    NSMutableArray *findItems = [[NSMutableArray alloc] init];
    for (CADShape *oldItem in self.listBefore)
    {
        for (CADShape *item in drawingCanvas.shapes)
        {
            if (item.uniqueID == oldItem.uniqueID)
            {
                [findItems addObject:item];
                continue;
            }
        }
    }
    
    [drawingCanvas.shapes removeObjectsInArray:findItems];
    [drawingCanvas.shapes addObjectsFromArray:self.listBefore];
    [drawingCanvas redraw];
}

- (void) redo:(id<DrawingCanvas>)drawingCanvas
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
    [drawingCanvas.shapes addObjectsFromArray:self.listAfter];
    [drawingCanvas redraw];
}

- (void)recordForUndo:(id<DrawingCanvas>)drawingCanvas
{
    for (CADShape *element in drawingCanvas.selection)
    {
        [self.listBefore addObject:[element copy]]; // for UNDO
    }
}

- (void)recordForRedo:(id<DrawingCanvas>)drawingCanvas
{
    for (CADShape *element in drawingCanvas.selection)
    {
        [self.listAfter addObject:[element copy]]; // for REDO
    }
    [drawingCanvas addCommandToHistory:self];
}

// touches events
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event view:(id<DrawingCanvas>)drawingCanvas
{
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event view:(id<DrawingCanvas>)drawingCanvas
{
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event view:(id<DrawingCanvas>)drawingCanvas
{
    [self recordForRedo:drawingCanvas];
    [self.delegateCommand onCommandEnd];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event view:(id<DrawingCanvas>)drawingCanvas
{
    
}

@end
