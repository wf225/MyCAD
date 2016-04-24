//
//  CADUndoManager.m
//  MyCAD
//
//  Created by wubil on 14-4-28.
//  Copyright (c) 2014 Feng. All rights reserved.
//

#import "CADUndoManager.h"
#import "CADCommand.h"

@implementation CADUndoManager

@synthesize canUndo = _canUndo;
@synthesize canRedo = _canRedo;

- (id)initWithCanvas:(id<DrawingCanvas>)drawingCanvas
{
    if (self = [super init]) {
        _drawingCanvas = drawingCanvas;
        _historyList = [[NSMutableArray alloc] init];
        _bufferArray = [[NSMutableArray alloc] init];
    }
    return self;
}

//! Return true if Redo operation is available
- (BOOL)canRedo
{
    return _bufferArray.count > 0;
}

//! Return true if Undo operation is available
- (BOOL)canUndo
{
    return _historyList.count > 0;
}

- (void)addCommandToHistory:(id<CADCommand>)command
{
    [_historyList addObject:command];
    [_bufferArray removeAllObjects];
    
    // raise state change event.
    [self.delegateUndo onUndoStateChanged];
}

- (void)clearHistory
{
    [_historyList removeAllObjects];
    [_bufferArray removeAllObjects];
    
    // raise state change event.
    [self.delegateUndo onUndoStateChanged];
}

- (void)undo
{
    if (!self.canUndo) {
        return;
    }
    
    id<CADCommand> command = [_historyList lastObject];
    [_bufferArray addObject:command];
    [_historyList removeLastObject];
    
    // execute the command object's undo method.
    [command undo:_drawingCanvas];
    
    // raise state change event.
    [self.delegateUndo onUndoStateChanged];
}

- (void)redo
{
    if (!self.canRedo) {
        return;
    }
    
    id<CADCommand> command = [_bufferArray lastObject];
    [_historyList addObject:command];
    [_bufferArray removeLastObject];
    
    // execute the command object's undo method.
    [command redo:_drawingCanvas];
    
    // raise state change event.
    [self.delegateUndo onUndoStateChanged];
}

@end
