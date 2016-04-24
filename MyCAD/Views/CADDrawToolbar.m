//
//  CADEditToolbar.m
//  MyCAD
//
//  Created by wubil on 14-4-17.
//  Copyright (c) 2014 Feng. All rights reserved.
//

#import "CADDrawToolbar.h"
#import "CADCommandManager.h"
#import "CADDrawCommand.h"

@implementation CADDrawToolbar

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
        [self addToolbar:7];
        
        [self addToolbarItem:0 normalImage:@"DrawTools_Circle.png" selectedBg:selectedBg target:self action:@selector(drawToolbarButtonDownHandle:)];
        [self addToolbarItem:1 normalImage:@"DrawTools_Polyline.png" selectedBg:selectedBg target:self action:@selector(drawToolbarButtonDownHandle:)];
        [self addToolbarItem:2 normalImage:@"DrawTools_Line.png" selectedBg:selectedBg target:self action:@selector(drawToolbarButtonDownHandle:)];
        [self addToolbarItem:3 normalImage:@"DrawTools_Rectange.png" selectedBg:selectedBg target:self action:@selector(drawToolbarButtonDownHandle:)];
        [self addToolbarItem:4 normalImage:@"DrawTools_Arc.png" selectedBg:selectedBg target:self action:@selector(drawToolbarButtonDownHandle:)];
        [self addToolbarItem:5 normalImage:@"DrawTools_Text.png" selectedBg:selectedBg target:self action:@selector(drawToolbarButtonDownHandle:)];
        [self addToolbarItem:6 normalImage:@"MarkTools_Brush.png" selectedBg:selectedBg target:self action:@selector(drawToolbarButtonDownHandle:)];
    }
    
    return self;
}

-(IBAction)drawToolbarButtonDownHandle:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    NSLog(@"drawToolbar tag=%d", (int)btn.tag);
    
    switch (btn.tag) {
        case 0:
            [CADCommandManager sharedInstance].drawShapeType = kShapeCircle;
            break;
        case 1:
            [CADCommandManager sharedInstance].drawShapeType = kShapePolyline;
            break;
        case 2:
            [CADCommandManager sharedInstance].drawShapeType = kShapeLine;
            break;
        case 3:
            [CADCommandManager sharedInstance].drawShapeType = kShapeRectagle;
            break;
        case 4:
            [CADCommandManager sharedInstance].drawShapeType = kShapeArc;
            break;
        case 5:
            [CADCommandManager sharedInstance].drawShapeType = kShapeText;
            break;
        case 6:
            [CADCommandManager sharedInstance].drawShapeType = kShapePath;
            break;
        default:
            break;
    }
    
    // set current active command is DrawCommand.
    // NOTE: drawShapeType must be specify before this.
    [CADCommandManager sharedInstance].activeCommandType = kDrawCommand;
    [CADCommandManager sharedInstance].delegateCommand = self;
}

- (void)setHidden:(BOOL)hidden
{
    // disable the DrawCommand when this view be hidden.
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
