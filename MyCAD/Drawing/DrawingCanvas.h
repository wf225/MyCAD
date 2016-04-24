//
//  DrawingCanvas.h
//  MyCAD
//
//  Created by wubil on 14-5-6.
//  Copyright (c) 2014 Feng. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol CADCommand;
@protocol DrawingCanvas;
@class GLKBaseEffect;

#pragma mark - delegate

@protocol CADCanvasDelegate <NSObject>
@optional
- (void)drawingCanvas:(id<DrawingCanvas>)canvas willBeginDrawing:(id<CADCommand>)tool;
- (void)drawingCanvas:(id<DrawingCanvas>)canvas didEndDrawing:(id<CADCommand>)tool;
@end

@protocol CADSelectionDelegate <NSObject>
- (void)onSelectioinChanged:(NSMutableArray *)selectedItems;
@end

#pragma mark - IDrawingCanvas

@protocol DrawingCanvas <NSObject>

// view
@property (nonatomic,readonly,retain) UIView *view;
//@property (nonatomic, assign) CGPoint worldCsOriginOffset; // reset the origion, 原坐标系为Quartz 2D绘图坐标系(X轴正方向向右,Y轴正方向向上)
//@property (nonatomic, readonly) CGAffineTransform deviceToWorldTransform; //convert the device CS to OpenGL CS
@property (nonatomic, readonly) CGFloat scaleFactor;

// delegate
@property (nonatomic, assign) id<CADCanvasDelegate> delegateCanvas;
@property (nonatomic, assign) id<CADSelectionDelegate> delegateSelection;

// Drawing properties
@property (nonatomic, strong) NSMutableArray *shapes;
@property (nonatomic, readonly) NSMutableArray *selection;
@property (nonatomic, readonly) int selectionCount;

// drawing
- (CGContextRef)drawContext; // for Quartz2D
@property (nonatomic, readonly) GLKBaseEffect *effect; // for OpenGL
- (CGPoint)getTouchLocation:(UITouch *)touch;
- (CGPoint)getTouchPreviousLocation:(UITouch *)touch;

- (void)redraw;
- (void)refreshCanvasWithCommand:(id<CADCommand>)command;
- (void)setNeedsDisplay;

// erase all
- (void)clear;

// undo / redo
- (BOOL)canUndo;
- (void)undoLatestStep;
- (BOOL)canRedo;
- (void)redoLatestStep;
- (void)addCommandToHistory:(id<CADCommand>)command;

@end
