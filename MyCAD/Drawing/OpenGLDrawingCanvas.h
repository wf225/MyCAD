//
//  GLDrawingCanvas.h
//  MyCAD
//
//  Created by wubil on 14-5-5.
//  Copyright (c) 2014 Feng. All rights reserved.
//

//#import <OpenGLES/ES3/gl.h>
//#import <OpenGLES/ES3/glext.h>
#import <GLKit/GLKit.h>
#import "DrawingCanvas.h"

// OpenGL drawing canvas
@interface OpenGLDrawingCanvas : GLKView<DrawingCanvas> // NSObject
{
    GLKVector4 clearColor;
    float left, right, bottom, top;
    GLKVector4 color;
}

@property GLKVector4 clearColor;
@property float left, right, bottom, top;
@property(readonly) GLKMatrix4 projectionMatrix;
@property GLKVector4 color;

//--------------
- (void)onLoad;

// view
@property (nonatomic,readonly,retain) UIView *view;
@property (nonatomic, assign) CGPoint worldCsOriginOffset;
@property (nonatomic, readonly) CGFloat scaleFactor;

// delegate
@property (nonatomic, assign) id<CADCanvasDelegate> delegateCanvas;
@property (nonatomic, assign) id<CADSelectionDelegate> delegateSelection;

// Drawing properties
@property (nonatomic, strong) NSMutableArray *shapes;
@property (nonatomic, readonly) NSMutableArray *selection;
@property (nonatomic, readonly) int selectionCount;

// drawing
@property (nonatomic, readonly) GLKBaseEffect *effect; // for OpenGL

// drawing
- (void)redraw;
//- (void)refreshCanvasWithCommand:(id<CADCommand>)command;

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
