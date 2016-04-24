//
//  CADEraseCommand.h
//  MyCAD
//
//  Created by wubil on 14-4-28.
//  Copyright (c) 2014 Feng. All rights reserved.
//

#import "CADCommandBase.h"
#import "CADLayer.h"

@interface CADSelectionCommand : CADCommandBase
{
    id<DrawingCanvas> _drawingCanvas;
}

- (id)initWithCanvas:(id<DrawingCanvas>)drawingCanvas;

- (void)redrawSelection:(CADLayer *)pen;
- (void)eraseSelection;
- (void)deselect;

@end
