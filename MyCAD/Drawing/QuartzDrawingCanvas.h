//
//  DrawingCanvas.h
//  MyCAD
//
//  Created by wubil on 14-4-14.
//  Copyright (c) 2014 Feng. All rights reserved.
//

#define CADDrawingViewVersion   1.0.0

#import <UIKit/UIKit.h>
#import "DrawingCanvas.h"


// Quartz2D drawing canvas
@interface QuartzDrawingCanvas : UIView<DrawingCanvas>

// get the current drawing
@property (nonatomic, strong) UIImage *image;

// view
@property(nonatomic,readonly,retain) UIView *view;

// delegate
@property (nonatomic, assign) id<CADCanvasDelegate> delegateCanvas;
@property (nonatomic, assign) id<CADSelectionDelegate> delegateSelection;

// Drawing properties
@property (nonatomic, strong) NSMutableArray *shapes;
@property (nonatomic, readonly) NSMutableArray *selection;
@property (nonatomic, readonly) int selectionCount;

// drawing
- (CGContextRef)drawContext;
- (void)redraw;
- (void)refreshCanvasWithCommand:(id<CADCommand>)command;

// erase all
- (void)clear;

// undo / redo
- (BOOL)canUndo;
- (void)undoLatestStep;
- (BOOL)canRedo;
- (void)redoLatestStep;
- (void)addCommandToHistory:(id<CADCommand>)command;

// gesture
- (void)registerGestureRecognizer;

@end
