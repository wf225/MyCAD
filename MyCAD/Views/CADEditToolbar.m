//
//  CADEditToolbar.m
//  MyCAD
//
//  Created by wubil on 14-4-27.
//  Copyright (c) 2014 Feng. All rights reserved.
//

#import "CADEditToolbar.h"
#import "CADCommandManager.h"
#import "CADDrawCommand.h"
#import "CADMainToolbar.h"
#import "CADSelectionCommand.h"

@implementation CADEditToolbar

- (id)initWithOwner:(UIView *)owner canvas:(id<DrawingCanvas>)drawingCanvas;
{
    _drawingCanvas = drawingCanvas;
    
    CGSize size = owner.bounds.size;
    CGFloat width = size.width;
    CGFloat height = UI_BUTTON_HEIGHT;
    
    // NOTE: subToolbar: size.height - height * 2
    if(self = [super initWithFrame:CGRectMake(0, size.height - height * 2, width, height)])
    {
        [owner addSubview:self]; // addSubview for owner
        
        // Set toolbar button style.
        self.buttonSpace = 30;
        self.buttonHeightRate = 1;
        double rgb = 210/255.0;
        self.backgroundColor = [UIColor colorWithRed:rgb green:rgb blue:rgb alpha:1];
        self.buttonHeight = self.frame.size.height * self.buttonHeightRate;
        self.buttonWidth = UI_BUTTON_WIDTH;
        
        //--------
        NSString *selectedBg = @"DrawTools_BtnSelectedBG.png";
        [self addToolbar:6];
        
        [self addToolbarItem:0 normalImage:@"Select_Move.png" selectedBg:selectedBg target:self action:@selector(editToolbarButtonDownHandle:)];
        [self addToolbarItem:1 normalImage:@"Select_Rotate.png" selectedBg:selectedBg target:self action:@selector(editToolbarButtonDownHandle:)];
        [self addToolbarItem:2 normalImage:@"Select_Scale.png" selectedBg:selectedBg target:self action:@selector(editToolbarButtonDownHandle:)];
        [self addToolbarItem:3 normalImage:@"Select_Erase.png" selectedBg:selectedBg target:self action:@selector(editToolbarButtonDownHandle:)];
        [self addToolbarItem:4 normalImage:@"Select_Mirror.png" selectedBg:selectedBg target:self action:@selector(editToolbarButtonDownHandle:)];
        [self addToolbarItem:5 normalImage:@"Select_Deselect.png" selectedBg:selectedBg target:self action:@selector(editToolbarButtonDownHandle:)];
        //[self addToolbarItem:6 normalImage:@"Select_Align.png" selectedBg:selectedBg target:self action:@selector(editToolbarButtonDownHandle:)];
    }
    
    self.hidden = true;
    
    // selection change delegate
    _drawingCanvas.delegateSelection = self;
    
    return self;
}

- (void)dealloc
{
    _drawingCanvas.delegateSelection = nil;
}

-(IBAction)editToolbarButtonDownHandle:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    NSLog(@"editToolbar tag=%d", (int)btn.tag);
    
    switch (btn.tag) {
        case 0:
            [CADCommandManager sharedInstance].activeCommandType = kMoveCommand;
            break;
        case 1:
            [CADCommandManager sharedInstance].activeCommandType = kRotateComand;
            break;
        case 2:
            [CADCommandManager sharedInstance].activeCommandType = kScaleCommand;
            break;
        case 3: //erase
        {
            [CADCommandManager sharedInstance].activeCommandType = kEraseCommand;
            CADSelectionCommand *selectionCommand = [[CADSelectionCommand alloc] initWithCanvas:_drawingCanvas];
            selectionCommand.delegateCommand = self;
            [selectionCommand eraseSelection];
            break;
        }
        case 4:
            [CADCommandManager sharedInstance].activeCommandType = kMirrorCommand;
            break;
        case 5: //deselect
        {
            [CADCommandManager sharedInstance].activeCommandType = kNullCommand;
            CADSelectionCommand *selectionCommand = [[CADSelectionCommand alloc] initWithCanvas:_drawingCanvas];
            selectionCommand.delegateCommand = self;
            [selectionCommand deselect];
            break;
        }
//        case 6: //align
//            [CADCommandManager sharedInstance].activeCommandType = kNullCommand;
//            break;
        default:
            [CADCommandManager sharedInstance].activeCommandType = kNullCommand;
            break;
    }
    
    [CADCommandManager sharedInstance].delegateCommand = self;
}

- (void)onSelectioinChanged:(NSMutableArray *)selectedItems
{
    if (selectedItems.count > 0) // show editing toolbar
    {
        [[CADMainToolbar sharedInstance] hiddenAllSubToolbars];
        self.hidden = false;
    }
    else
    {
        self.hidden = true;
    }
}

- (void)setHidden:(BOOL)hidden
{
    // disable the EditCommand when this view be hidden.
    if (hidden) {
        [CADCommandManager sharedInstance].activeCommandType = kNullCommand;
    }
    
    [super setHidden:hidden];
}

- (void)onCommandEnd
{
    for (UIButton *btn in self.subviews)
    {
        btn.selected = false;
    }
}

@end
