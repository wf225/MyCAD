//
//  CADMainToolbar.m
//  MyCAD
//
//  Created by wubil on 14-4-17.
//  Copyright (c) 2014 Feng. All rights reserved.
//

#import "CADMainToolbar.h"
#import "CADDrawToolbar.h"
#import "CADColorToolbar.h"
#import "CADEditToolbar.h"
#import "CADCommandManager.h"

@implementation CADMainToolbar
//@synthesize editToolbar = _editToolbar;

+ (CADMainToolbar *) sharedInstance;
{
    static CADMainToolbar *mainToolbar = nil;
    if (!mainToolbar)
    {
        mainToolbar = [[CADMainToolbar alloc] init];
    }
    
    return mainToolbar;
}

- (void)setWithOwner:(UIView *)owner canvas:(id<DrawingCanvas>)drawingCanvas;
{
    _drawingCanvas = drawingCanvas;
    
    // set frame with owner.size
    CGSize size = owner.bounds.size;
    CGFloat width = size.width;
    CGFloat height = UI_BUTTON_HEIGHT;
    
    [self setFrame:CGRectMake(0, size.height - height, width, height)];
    [owner addSubview:self]; // addSubview for owner
    
    // set toolbar button style.
    self.buttonSpace = 20;
    self.buttonHeightRate = 1;
    self.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    self.buttonHeight = self.frame.size.height * self.buttonHeightRate;
    self.buttonWidth = UI_BUTTON_WIDTH;
    
    // add toolbar items
    NSString *selectedBg = @"MainTools_BtnSelectedBg.png";
    [self addToolbar:10];
    
    [self addToolbarItem:0 normalImage:@"MainTools_Draw.png" selectedBg:selectedBg target:self action:@selector(drawButtonDownHandle:)];
    CADDrawToolbar *_drawToolbar = [[CADDrawToolbar alloc] initWithOwner:owner canvas:drawingCanvas];
    [self addSubToolbar:_drawToolbar]; // Add draw toolbar to main toolbar.
    
    [self addToolbarItem:1 normalImage:@"MainTools_Color.png" selectedBg:selectedBg target:self action:@selector(markButtonDownHandle:)];
    CADColorToolbar *_colorToolbar = [[CADColorToolbar alloc] initWithOwner:owner canvas:drawingCanvas];
    [self addSubToolbar:_colorToolbar]; // Add color toolbar to main toolbar.
    
    [self addToolbarItem:2 normalImage:@"MainTools_Dimension.png" selectedBg:selectedBg target:self action:@selector(dimensionButtonDownHandle:)];
    
    [self addToolbarItem:3 normalImage:@"MainTools_Mark.png" selectedBg:selectedBg target:self action:@selector(markButtonDownHandle:)];
    
    [self addToolbarItem:4 normalImage:@"MainTools_Undo.png.png" selectedBg:selectedBg target:self action:@selector(markButtonDownHandle:)];
    [self addToolbarItem:5 normalImage:@"MainTools_Redo" selectedBg:selectedBg target:self action:@selector(markButtonDownHandle:)];
    
    [self addToolbarItem:6 normalImage:@"MainTools_Layer.png" selectedBg:selectedBg target:self action:@selector(layerButtonDownHandle:)];
    
    [self addToolbarItem:7 normalImage:@"MainTools_ViewMode.png" selectedBg:selectedBg target:self action:@selector(markButtonDownHandle:)];
    [self addToolbarItem:8 normalImage:@"MainTools_Model.png" selectedBg:selectedBg target:self action:@selector(markButtonDownHandle:)];
    [self addToolbarItem:9 normalImage:@"MainTools_Share.png" selectedBg:selectedBg target:self action:@selector(markButtonDownHandle:)];
    
    // NOTE: editing toolbar, don't add to SubToolbar
    _editToolbar = [[CADEditToolbar alloc] initWithOwner:owner canvas:drawingCanvas];
    
    [self moveToButtonWithIndex:0];
}

- (IBAction)drawButtonDownHandle:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    NSLog(@"drawButtonDownHandle tag=%d", (int)btn.tag);
    
    if (!btn.selected)
    {
        [CADCommandManager sharedInstance].activeCommandType = kNullCommand;
    }
    
    _editToolbar.hidden = true;
}

- (IBAction)dimensionButtonDownHandle:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    NSLog(@"dimensionButtonDownHandle tag=%d", (int)btn.tag);
    
    _editToolbar.hidden = true;
}

- (IBAction)markButtonDownHandle:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    NSLog(@"markButtonDownHandle tag=%d", (int)btn.tag);
    
    _editToolbar.hidden = true;
}

- (IBAction)layerButtonDownHandle:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    NSLog(@"layerButtonDownHandle tag=%d", (int)btn.tag);

    _editToolbar.hidden = true;
}

@end
