//
//  CADUndoManager.h
//  MyCAD
//
//  Created by wubil on 14-4-28.
//  Copyright (c) 2014 Feng. All rights reserved.
//

@protocol CADCommand;
@protocol DrawingCanvas;


@protocol CADUndoDelegate <NSObject>

- (void)onUndoStateChanged;

@end


@interface CADUndoManager : NSObject
{
    id<DrawingCanvas> _drawingCanvas;
    NSMutableArray *_historyList;
    NSMutableArray *_bufferArray;
}

@property (nonatomic, readonly)BOOL canUndo;
@property (nonatomic, readonly)BOOL canRedo;

@property (nonatomic, assign) id<CADUndoDelegate> delegateUndo;

- (id)initWithCanvas:(id<DrawingCanvas>)drawingCanvas;
- (void)addCommandToHistory:(id<CADCommand>)command;
- (void)clearHistory;

- (void)undo;
- (void)redo;

@end
