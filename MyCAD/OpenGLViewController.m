//
//  OpenGLViewController.m
//  MyCAD
//
//  Created by wubil on 14-5-2.
//  Copyright (c) 2014 Feng. All rights reserved.
//

#import "OpenGLViewController.h"
#import "OpenGLDrawingCanvas.h"
#import "CADMainToolbar.h"

@interface OpenGLViewController ()
{

}

@property (strong, nonatomic) EAGLContext *context;
@property (strong, nonatomic) GLKBaseEffect *effect;

- (void)setupGL;
- (void)tearDownGL;

@end

@implementation OpenGLViewController
@synthesize glView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //self.glView.delegateCanvas = self;
    [glView registerGestureRecognizer];
    
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    if (!self.context) {
        NSLog(@"Failed to create ES context");
    }
    
    glView.context = self.context;
    
    // Configure renderbuffers created by the view
    glView.drawableColorFormat = GLKViewDrawableColorFormatRGBA8888;
    glView.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    glView.drawableStencilFormat = GLKViewDrawableStencilFormat8;
    // Enable multisampling
    glView.drawableMultisample = GLKViewDrawableMultisample4X;
    
    glView.clearColor = GLKVector4Make(1.0, 1.0, 1.0, 0.0);
    glView.color = GLKVector4Make(1, 0, 0, 0.0);
    
    //[glView onLoad];
    [self setupGL];
    
    // add toolbar
    [[CADMainToolbar sharedInstance]setWithOwner:self.view canvas:glView];
}

- (void)dealloc
{
    [self tearDownGL];
    
    if ([EAGLContext currentContext] == self.context) {
        [EAGLContext setCurrentContext:nil];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    if ([self isViewLoaded] && ([[self view] window] == nil)) {
        self.view = nil;
        
        [self tearDownGL];
        
        if ([EAGLContext currentContext] == self.context) {
            [EAGLContext setCurrentContext:nil];
        }
        self.context = nil;
    }
    
    // Dispose of any resources that can be recreated.
}

- (void)setupGL
{
    [EAGLContext setCurrentContext:self.context];
    [self setViewportOrientation:self.interfaceOrientation view:self.glView];
}

- (void)tearDownGL
{
    
}

#pragma mark - GLKViewDelegate, GLKViewControllerDelegate

//- (void)glkViewControllerUpdate:(GLKViewController *)controller
//{
//    //NSLog(@"in glkViewControllerUpdate:controller");
//    //[scene update];
//    // 15
//    //[scene update:controller.timeSinceLastUpdate];
//}
//
//- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
//{
//    //NSLog(@"in glkView:drawInRect:");
//}

// Orientation
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self setViewportOrientation:toInterfaceOrientation view:self.glView];
}

- (void)setViewportOrientation:(UIInterfaceOrientation)interfaceOrientation view:(OpenGLDrawingCanvas *)view
{
    if (interfaceOrientation == UIInterfaceOrientationPortrait
        || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown)
    {
//        view.left   = -glView.frame.size.width / 2; // -300;
//        view.right  =  glView.frame.size.width / 2; //300;
//        view.bottom = -glView.frame.size.height / 2; //-200;
//        view.top    =  glView.frame.size.height / 2; //200;
        
        //glViewport(0, 0, glView.frame.size.width, glView.frame.size.height);
        
//        view.left = -glView.worldCsOriginOffset.x;
//        view.right = glView.frame.size.width - glView.worldCsOriginOffset.x;
//        view.top = glView.worldCsOriginOffset.y;
//        view.bottom = -(glView.frame.size.height - glView.worldCsOriginOffset.y);
    }
    else
    {
//        view.left   = -glView.frame.size.height / 2; // -300;
//        view.right  =  glView.frame.size.height / 2; //300;
//        view.bottom = -glView.frame.size.width / 2; //-200;
//        view.top    =  glView.frame.size.width / 2; //200;
        
//        view.left = -glView.worldCsOriginOffset.y;
//        view.right = (glView.frame.size.height - glView.worldCsOriginOffset.y);
//        view.top = (glView.frame.size.width - glView.worldCsOriginOffset.x);
//        view.bottom = -glView.worldCsOriginOffset.x;
    }
}

@end
