//
//  CADColorToolbar.m
//  MyCAD
//
//  Created by wubil on 14-4-17.
//  Copyright (c) 2014 Feng. All rights reserved.
//

#import "CADColorToolbar.h"
#import "CADLayerManager.h"
#import "CADSelectionCommand.h"

@implementation CADColorToolbar

@synthesize buttonWidth;
@synthesize buttonHeight;
@synthesize buttonHeightRate;
@synthesize buttonSpace;

- (id)initWithOwner:(UIView *)owner canvas:(id<DrawingCanvas>)drawingCanvas
{
    _colorList = [[NSArray alloc] initWithObjects:
        [UIColor blackColor],
        [UIColor redColor],
        [UIColor greenColor],
        [UIColor blueColor],
        [UIColor cyanColor],
        [UIColor yellowColor],
        [UIColor magentaColor],
        [UIColor orangeColor],
        [UIColor purpleColor],
        [UIColor brownColor],
        nil];
    
    _drawingCanvas = drawingCanvas;
    
    CGSize size = owner.bounds.size;
    CGFloat width = size.width;
    CGFloat height = UI_BUTTON_HEIGHT;
    
    if(self = [super initWithFrame:CGRectMake(0, size.height - UI_BUTTON_HEIGHT * 2, width, height)])
    {
        [owner addSubview:self]; // addSubview for owner
        
        // Set toolbar button style.
        self.buttonSpace = 35;
        double rgb = 210/255.0;
        self.backgroundColor = [UIColor colorWithRed:rgb green:rgb blue:rgb alpha:1];
        self.buttonHeightRate = 0.7;
        self.buttonHeight = self.frame.size.height * self.buttonHeightRate;
        self.buttonWidth = self.buttonHeight; // UI_BUTTON_WIDTH;
        
        //--------
        [self addToolbar:10];
        [self addColorToolbarItem:0 backgroundColor:_colorList[0] target:self action:@selector(colorToolbarButtonDownHandle:)];
        [self addColorToolbarItem:1 backgroundColor:_colorList[1] target:self action:@selector(colorToolbarButtonDownHandle:)];
        [self addColorToolbarItem:2 backgroundColor:_colorList[2] target:self action:@selector(colorToolbarButtonDownHandle:)];
        [self addColorToolbarItem:3 backgroundColor:_colorList[3] target:self action:@selector(colorToolbarButtonDownHandle:)];
        [self addColorToolbarItem:4 backgroundColor:_colorList[4] target:self action:@selector(colorToolbarButtonDownHandle:)];
        [self addColorToolbarItem:5 backgroundColor:_colorList[5] target:self action:@selector(colorToolbarButtonDownHandle:)];
        [self addColorToolbarItem:6 backgroundColor:_colorList[6] target:self action:@selector(colorToolbarButtonDownHandle:)];
        [self addColorToolbarItem:7 backgroundColor:_colorList[7] target:self action:@selector(colorToolbarButtonDownHandle:)];
        [self addColorToolbarItem:8 backgroundColor:_colorList[8] target:self action:@selector(colorToolbarButtonDownHandle:)];
        [self addColorToolbarItem:9 backgroundColor:_colorList[9] target:self action:@selector(colorToolbarButtonDownHandle:)];
    }
    
    return self;
}

// add toolbar item with a color button
- (void)addColorToolbarItem:(int)index backgroundColor:(UIColor *)backgroundColor target:(id)target action:(SEL)buttonDownAction
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    // Add action for button
    [btn addTarget:self action:@selector(internalButtonDownHandle:) forControlEvents:UIControlEventTouchUpInside];
    [btn addTarget:target action:buttonDownAction forControlEvents:UIControlEventTouchUpInside];
    
    btn.tag = index;
    
    // set button size
    double startOffset = self.buttonSpace;
    CGFloat contentWidth = self.buttonNumber * (self.buttonWidth + self.buttonSpace) - self.buttonSpace; // -offsetEnd.
    if (contentWidth < self.frame.size.width)
    {
        startOffset = (self.frame.size.width - contentWidth) / 2.0;
        if (startOffset < self.buttonSpace) {
            startOffset = self.buttonSpace;
        }
    }
    CGFloat x = startOffset + index * (self.buttonWidth + self.buttonSpace);
    CGFloat y = self.frame.size.height * ( 1 - self.buttonHeightRate) / 2.0;
    [btn setFrame:CGRectMake(x, y, self.buttonWidth, self.buttonHeight)];
    
    btn.backgroundColor = backgroundColor;
    btn.layer.cornerRadius = 8; // RoundedRect
    
    // selected background image
    NSString *selectedBg = @"Color_Button_SelectedBg";
    [btn setBackgroundImage:[[UIImage imageNamed:selectedBg]stretchableImageWithLeftCapWidth:0.0 topCapHeight:0.0] forState:UIControlStateSelected];
    
    btn.selected = false;
    [self addSubview:btn];
}

-(IBAction)colorToolbarButtonDownHandle:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    NSLog(@"colorToolbar tag=%d", (int)btn.tag);
    
    int colorIndex = (int)btn.tag;
    [CADLayerManager sharedInstance].drawingPen.strokeColor = ((UIColor *)_colorList[colorIndex]).CGColor;
    
    // refresh the selected items with the new color
    CADSelectionCommand *selectionCommand = [[CADSelectionCommand alloc] initWithCanvas:_drawingCanvas];
    [selectionCommand redrawSelection:[CADLayerManager sharedInstance].drawingPen];
}

@end
