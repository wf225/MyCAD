//
//  CADViewController.h
//  MyCAD
//
//  Created by wubil on 14-4-15.
//  Copyright (c) 2014 Feng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuartzDrawingCanvas.h"
#import "UIControls/UIScrollToolbarView.h"


@interface CADViewController : UIViewController<UIActionSheetDelegate, CADCanvasDelegate>

@property (nonatomic, unsafe_unretained) IBOutlet QuartzDrawingCanvas *drawingCanvas;
//@property (nonatomic) IBOutlet UIScrollToolbarView *scrollView;

@property (nonatomic, unsafe_unretained) IBOutlet UISlider *lineWidthSlider;
@property (nonatomic, unsafe_unretained) IBOutlet UISlider *lineAlphaSlider;
@property (nonatomic, unsafe_unretained) IBOutlet UIImageView *previewImageView;

@property (nonatomic, unsafe_unretained) IBOutlet UIBarButtonItem *undoButton;
@property (nonatomic, unsafe_unretained) IBOutlet UIBarButtonItem *redoButton;
@property (nonatomic, unsafe_unretained) IBOutlet UIBarButtonItem *colorButton;
@property (nonatomic, unsafe_unretained) IBOutlet UIBarButtonItem *toolButton;

// actions
- (IBAction)undoAction:(id)sender;
- (IBAction)redoAction:(id)sender;
- (IBAction)clearAction:(id)sender;
- (IBAction)takeScreenshotAction:(id)sender;

// settings
//- (IBAction)colorChange:(id)sender;
//- (IBAction)toolChange:(id)sender;
//- (IBAction)toggleWidthSlider:(id)sender;
//- (IBAction)widthChange:(UISlider *)sender;
//- (IBAction)toggleAlphaSlider:(id)sender;
//- (IBAction)alphaChange:(UISlider *)sender;

@end
