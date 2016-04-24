//
//  CADMainToolbar.h
//  MyCAD
//
//  Created by wubil on 14-4-17.
//  Copyright (c) 2014 Feng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIScrollToolbarView.h"
#import "DrawingCanvas.h"

@class CADEditToolbar;

@interface CADMainToolbar : UIScrollToolbarView
{
    id<DrawingCanvas> _drawingCanvas;
    CADEditToolbar *_editToolbar;
}

//@property (nonatomic, strong)CADEditToolbar *editToolbar;

+ (CADMainToolbar *) sharedInstance;
- (void)setWithOwner:(UIView *)owner canvas:(id<DrawingCanvas>)drawingCanvas;

@end
