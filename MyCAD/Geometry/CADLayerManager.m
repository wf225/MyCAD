//
//  CADLayerManager.m
//  MyCAD
//
//  Created by wubil on 14-4-19.
//  Copyright (c) 2014 Feng. All rights reserved.
//

#import "CADLayerManager.h"

@implementation CADLayerManager
@synthesize drawingPen = _drawingPen;
@synthesize layers = _layers;

+ (CADLayerManager *) sharedInstance;
{
    static CADLayerManager *layerManager = nil;
    
    if (!layerManager)
    {
        layerManager = [[CADLayerManager alloc] init];
        
        // defaulet layer for test
        layerManager.drawingPen = [[CADLayer alloc]initWithName:@"Layer_1"];
    }
    
    return layerManager;
}

@end
