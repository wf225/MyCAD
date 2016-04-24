//
//  UIScrollToolbarView.m
//  MyCAD
//
//  Created by wubil on 14-4-16.
//  Copyright (c) 2014 Feng. All rights reserved.
//

#import "UIScrollToolbarView.h"

@interface UIScrollToolbarView ()
{
    UIButton *_previousSelectedButton;
}

@end

@implementation UIScrollToolbarView
@synthesize buttonNumber;
@synthesize currentButtonIndex;
@synthesize buttonWidth;
@synthesize buttonHeight;
@synthesize buttonHeightRate;
@synthesize buttonSpace;
@synthesize uiDelegate;
@synthesize subToolbars = _subToolbars;

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self internalInit];
    }
    return self;
}

- (void)awakeFromNib
{
    [self internalInit];
}

- (void)internalInit
{
    _subToolbars = [[NSMutableArray alloc]init];
    
    self.showsHorizontalScrollIndicator = false;
    self.showsVerticalScrollIndicator = false;
    
    self.buttonSpace = UI_BUTTON_SPACE;
    self.buttonHeightRate = UI_BUTTON_HEIGHT_RATE;
    self.buttonHeight = self.frame.size.height * self.buttonHeightRate;
    self.buttonWidth = self.buttonHeight; // * 1.2; // UI_BUTTON_WIDTH;
}

-(void)resetScrollView
{
    for (UIView *one in self.subviews)
    {
        [one removeFromSuperview];
    }
}

-(void)moveToButtonWithIndex:(NSUInteger)butInedex
{
    int tmp = (int)butInedex > 0 ? (int)butInedex : 0;
    tmp = tmp > (int)buttonNumber ? (int)buttonNumber : tmp;
    CGFloat x = tmp * (buttonWidth + buttonSpace) + buttonWidth/2.0;
    CGFloat scrollWidth = self.frame.size.width / 2.0;
    CGPoint curOffset = self.contentOffset;    
    CGFloat sub = curOffset.x + scrollWidth - x;
    curOffset.x -= sub;
    if (curOffset.x < 0)
    {
        curOffset.x = 0;
    }
    
    [self setContentOffset:curOffset animated:YES];
}

-(void)addToolbar:(int)butNumber
{
    [self resetScrollView];
    
    self.buttonNumber = butNumber;
    
    CGFloat contentWidth = self.buttonNumber * (self.buttonWidth + self.buttonSpace) + self.buttonSpace; // -offsetEnd.
    if (contentWidth < self.frame.size.width)
    {
        contentWidth = self.frame.size.width + 2; // +2 out of current view.width, to showsHorizontalScroll
    }
    
    [self setContentSize:CGSizeMake(contentWidth, self.frame.size.height)];
}

- (void)addSubToolbar:(UIScrollToolbarView *)subToolbar
{
    subToolbar.hidden = true; // hidden the sub toolbar at first.
    [_subToolbars addObject:subToolbar];
}

- (void)hiddenAllSubToolbars
{
    for (UIButton *btn in self.subviews) // unselect toolbar items
    {
        btn.selected = false;
    }
    
    for (int i = 0; i < _subToolbars.count; i++)
    {
        UIScrollToolbarView *subToolbar = [_subToolbars objectAtIndex:i];        
        subToolbar.hidden = true; // hidden all sub toolbars
        
        for (UIButton *btn in subToolbar.subviews) // unselect sub toolbar items
        {
            btn.selected = false;
        }
    }
}

-(IBAction)internalButtonDownHandle:(UIButton *)sender
{
    if(_previousSelectedButton != nil && _previousSelectedButton != sender)
    {
        _previousSelectedButton.selected = false;
    }

    _previousSelectedButton = sender;
    
    // responds the delegate
    if ([uiDelegate respondsToSelector:@selector(selectedButDown:)])
    {
        [uiDelegate selectedButDown:sender];
    }
    
    //
    sender.selected = !sender.selected;
    // show/hidden sub toolbar.
    for (int i = 0; i < _subToolbars.count; i++)
    {
        UIScrollToolbarView *subToolbar = [_subToolbars objectAtIndex:i];
        if (i == sender.tag)
        {
            subToolbar.hidden = !subToolbar.hidden;
        }
        else
        {
            subToolbar.hidden = true; // hidden others
        }
        
        if (subToolbar.hidden)
        {
            for (UIButton *btn in subToolbar.subviews) // unselect others
            {
                btn.selected = false;
            }
        }
    }
}

- (void)addToolbarItem:(int)index normalImage:(NSString *)normalImage selectedBg:(NSString *)selectedBg target:(id)target action:(SEL)buttonDownAction
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
    
    [btn setImage:[[UIImage imageNamed:normalImage]stretchableImageWithLeftCapWidth:0.0 topCapHeight:0.0] forState:UIControlStateNormal];
    // selected background image
    [btn setBackgroundImage:[[UIImage imageNamed:selectedBg]stretchableImageWithLeftCapWidth:0.0 topCapHeight:0.0] forState:UIControlStateSelected];
    
    btn.selected = false;
    [self addSubview:btn];
}

- (void)addToolbarItem:(int)index normalImage:(NSString *)normalImage selectedBg:(NSString *)selectedBg
{
    return [self addToolbarItem:index normalImage:normalImage selectedBg:selectedBg target:self action:nil];
}

//- (void)addToolbarItem:(int)index title:(NSString *)btnTitle
//{
//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    
//    // Add action for button
//    [btn addTarget:self action:@selector(internalButtonDownHandle:) forControlEvents:UIControlEventTouchUpInside];
//    
//    btn.tag = index;
//    CGFloat x = buttonSpace + index * (buttonWidth + buttonSpace);
//    CGFloat y = self.frame.size.height * ( 1 - self.buttonHeightRate) / 2.0;
//    [btn setFrame:CGRectMake(x, y, buttonWidth, buttonHeight)];
//    
//    [btn setTitle:btnTitle forState:UIControlStateNormal];
//    //btn.backgroundColor = [UIColor redColor];
//    btn.layer.cornerRadius = 8; // RoundedRect
//    
//    btn.selected = false;
//    [self addSubview:btn];
//}

@end
