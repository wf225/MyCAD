//
//  OpenGLViewController.h
//  MyCAD
//
//  Created by wubil on 14-5-2.
//  Copyright (c) 2014 Feng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>
#import "OpenGLDrawingCanvas.h"

@interface OpenGLViewController : UIViewController// GLKViewController

@property (strong, retain) IBOutlet OpenGLDrawingCanvas *glView;

@end
