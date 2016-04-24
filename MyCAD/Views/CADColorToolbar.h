//
//  CADColorToolbar.h
//  MyCAD
//
//  Created by wubil on 14-4-17.
//  Copyright (c) 2014 Feng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIScrollToolbarView.h"
#import "DrawingCanvas.h"

@interface CADColorToolbar : UIScrollToolbarView
{
    id<DrawingCanvas> _drawingCanvas;
    NSArray *_colorList;
}

- (id)initWithOwner:(UIView *)owner canvas:(id<DrawingCanvas>)drawingCanvas;

@end
