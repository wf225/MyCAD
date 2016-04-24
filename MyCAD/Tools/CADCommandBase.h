//
//  CADCommandBase.h
//  MyCAD
//
//  Created by wubil on 14-4-29.
//  Copyright (c) 2014 Feng. All rights reserved.
//

#import "CADCommand.h"

@interface CADCommandBase : NSObject<CADCommand>

// delegate
@property (nonatomic, assign) id<CADCommandDelegate> delegateCommand;

@property (nonatomic, strong)NSMutableArray *listBefore;
@property (nonatomic, strong)NSMutableArray *listAfter;

- (void)recordForUndo:(id<DrawingCanvas>)drawingCanvas;
- (void)recordForRedo:(id<DrawingCanvas>)drawingCanvas;

@end
