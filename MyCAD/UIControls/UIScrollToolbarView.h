//
//  UIScrollToolbarView.h
//  MyCAD
//
//  Created by wubil on 14-4-16.
//  Copyright (c) 2014 Feng. All rights reserved.
//

#define UI_BUTTON_HEIGHT           50.0
#define UI_BUTTON_HEIGHT_RATE      1.0
#define UI_BUTTON_WIDTH            70.0
#define UI_BUTTON_SPACE            0.0

#import <UIKit/UIKit.h>

@protocol UIScrollToolbarViewDelegate <NSObject>
-(void)selectedButDown:(UIButton *)sender;
@end

@interface UIScrollToolbarView : UIScrollView

@property(nonatomic, assign)id<UIScrollToolbarViewDelegate> uiDelegate;

@property(assign, nonatomic)NSInteger buttonNumber;
@property(assign, nonatomic)NSInteger currentButtonIndex;
@property(assign, nonatomic)CGFloat buttonWidth;
@property(assign, nonatomic)CGFloat buttonHeight;
@property(assign, nonatomic)CGFloat buttonHeightRate;
@property(assign, nonatomic)CGFloat buttonSpace;

@property(strong, nonatomic)NSMutableArray *subToolbars;

- (void)addToolbar:(int)butNumber;

- (void)addToolbarItem:(int)index normalImage:(NSString *)normalImage selectedBg:(NSString *)selectedBg;
- (void)addToolbarItem:(int)index normalImage:(NSString *)normalImage selectedBg:(NSString *)selectedBg target:self action:(SEL)buttonDownAction;
- (void)moveToButtonWithIndex:(NSUInteger)butInedex;
//- (void)addToolbarItem:(int)index title:(NSString *)btnTitle;

- (void)addSubToolbar:(UIScrollToolbarView *)subToolbar;
- (void)hiddenAllSubToolbars;

-(IBAction)internalButtonDownHandle:(UIButton *)sender;

@end
