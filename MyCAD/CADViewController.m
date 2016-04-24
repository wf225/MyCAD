//
//  CADViewController.m
//  MyCAD
//
//  Created by wubil on 14-4-15.
//  Copyright (c) 2014 Feng. All rights reserved.
//

#import "CADViewController.h"
#import "CADMainToolbar.h"

#define kActionSheetColor       100
#define kActionSheetTool        101

@implementation CADViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // init draw canvas.
    //[self.drawingCanvas onInit];
    // set the delegate
    self.drawingCanvas.delegateCanvas = self;
    [self.drawingCanvas registerGestureRecognizer];
    
    // start with a black pen
    //self.lineWidthSlider.value = self.drawingCanvas.lineWidth;
    
    // init the preview image
    self.previewImageView.layer.borderColor = [[UIColor blackColor] CGColor];
    self.previewImageView.layer.borderWidth = 2.0f;
    
    // add toolbar
    [[CADMainToolbar sharedInstance]setWithOwner:self.view canvas:self.drawingCanvas];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (void)updateState
{
    self.undoButton.enabled = [self.drawingCanvas canUndo];
    self.redoButton.enabled = [self.drawingCanvas canRedo];
}

- (IBAction)takeScreenshotAction:(id)sender
{
    // show the preview image
    self.previewImageView.image = self.drawingCanvas.image;
    self.previewImageView.hidden = NO;
    
    // close it after 3 seconds
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 3 * NSEC_PER_SEC), dispatch_get_current_queue(), ^{
        self.previewImageView.hidden = YES;
    });
}

- (IBAction)undoAction:(id)sender
{
    [self.drawingCanvas undoLatestStep];
    [self updateState];
}

- (IBAction)redoAction:(id)sender
{
    [self.drawingCanvas redoLatestStep];
    [self updateState];
}

- (IBAction)clearAction:(id)sender
{
    [self.drawingCanvas clear];
    [self updateState];
}


#pragma mark - CADDrawing View Delegate

//- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx
//{
//    
//}

- (void)drawingCanvas:(id<DrawingCanvas>)canvas willBeginDrawing:(id<CADCommand>)tool
{
    
}

- (void)drawingCanvas:(id<DrawingCanvas>)canvas didEndDrawing:(id<CADCommand>)tool
{
    [self updateState];
}


//#pragma mark - Action Sheet Delegate

- (IBAction)toggleWidthSlider:(id)sender
{
    // toggle the slider
    self.lineWidthSlider.hidden = !self.lineWidthSlider.hidden;
    self.lineAlphaSlider.hidden = YES;
}


- (IBAction)widthChange:(UISlider *)sender
{
    //self.drawingCanvas.lineWidth = sender.value;
}

- (IBAction)toggleAlphaSlider:(id)sender
{
    // toggle the slider
    self.lineAlphaSlider.hidden = !self.lineAlphaSlider.hidden;
    self.lineWidthSlider.hidden = YES;
}

- (IBAction)alphaChange:(UISlider *)sender
{
    //self.drawingCanvas.lineAlpha = sender.value;
}

@end
