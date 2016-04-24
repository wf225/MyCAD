//
//  CADEditToolbar.h
//  MyCAD
//
//  Created by wubil on 14-4-27.
//  Copyright (c) 2014 Feng. All rights reserved.
//

#import "UIScrollToolbarView.h"
#import "CADCommand.h"

//! When user select an entity, edit toolbar will be shown.
@interface CADEditToolbar : UIScrollToolbarView<CADSelectionDelegate, CADCommandDelegate>
{
    id<DrawingCanvas> _drawingCanvas;
}

- (id)initWithOwner:(UIView *)owner canvas:(id<DrawingCanvas>)drawingCanvas;

@end
