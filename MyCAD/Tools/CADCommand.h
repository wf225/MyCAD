//
//  DrawTool.h
//  MyCAD
//
//  Created by wubil on 14-4-14.
//  Copyright (c) 2014 Feng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CADConstants.h"
#import "DrawingCanvas.h"

typedef enum {
    kNullCommand,
    kDrawCommand,
    kMoveCommand,
    kRotateComand,
    kScaleCommand,
    kMirrorCommand,
    kEraseCommand,
    kDeselectCommand
} CADCommandType;


#pragma mark - CADCommandDelegate
@protocol CADCommandDelegate <NSObject>

- (void)onCommandEnd;

@end


#pragma mark - CADCommand
@protocol CADCommand <NSObject>

+ (id) create;

- (void)draw:(id<DrawingCanvas>)drawingCanvas drawMode:(CADDrawMode)drawMode;
- (void)undo:(id<DrawingCanvas>)drawingCanvas;
- (void)redo:(id<DrawingCanvas>)drawingCanvas;

// delegate
@property (nonatomic, assign) id<CADCommandDelegate> delegateCommand;

// touches events
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event view:(id<DrawingCanvas>)drawingCanvas;
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event view:(id<DrawingCanvas>)drawingCanvas;
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event view:(id<DrawingCanvas>)drawingCanvas;
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event view:(id<DrawingCanvas>)drawingCanvas;

@end

