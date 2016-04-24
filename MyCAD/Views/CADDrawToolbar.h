//
//  CADEditToolbar.h
//  MyCAD
//
//  Created by wubil on 14-4-17.
//  Copyright (c) 2014 Feng. All rights reserved.
//

#import "UIScrollToolbarView.h"
#import "CADCommand.h"

@interface CADDrawToolbar : UIScrollToolbarView<CADCommandDelegate>
{
    id<DrawingCanvas> _drawingCanvas;
}

- (id)initWithOwner:(UIView *)owner canvas:(id<DrawingCanvas>)drawingCanvas;

@end
