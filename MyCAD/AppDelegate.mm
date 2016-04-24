//
//  CADAppDelegate.m
//  MyCAD3
//
//  Created by wubil on 14-4-16.
//  Copyright (c) 2014 Feng. All rights reserved.
//

#import "AppDelegate.h"
#import "CADViewController.h"
#import "OpenGLViewController.h"
//
//#import "Line2d.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
#ifdef UseOpenGL
    // 2 - Draw with opengl.
    OpenGLViewController *glViewController = [[OpenGLViewController alloc] initWithNibName:@"OpenGLViewController" bundle:nil];
    self.window.rootViewController = glViewController;
#else
    // 1- Draw with iOS CoreGraphics.
    CADViewController *viewController = [[CADViewController alloc] initWithNibName:@"CADViewController" bundle:nil];
    self.window.rootViewController = viewController;
#endif
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    
    // TODO: 几何关系运算
//    Point2d pt1 = Point2d(0, 0);
//    Point2d pt2 = Point2d(10, 0);
//    Point2d pt3 = Point2d(5, -10);
//    Point2d pt4 = Point2d(5, 10);
//    
//    Line2d line1 = Line2d(pt1, pt2);
//    Line2d line2 = Line2d(pt3, pt4);
//    Point2d ptCross;
//    bool isCross = line1.cross2Line(line2, ptCross);
//    
//    BOOL result = mgIsBetweenLine(pt1, pt2, pt3);
//    NSLog(@"result=%s", result ? "TRUE" : "FALSE");
//    
//    delete &pt1, &pt2, &pt3, &pt4;
//    delete &line1, &line2;
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
