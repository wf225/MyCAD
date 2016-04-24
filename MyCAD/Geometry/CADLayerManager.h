//
//  CADLayerManager.h
//  MyCAD
//
//  Created by wubil on 14-4-19.
//  Copyright (c) 2014 Feng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CADLayer.h"

@interface CADLayerManager : NSObject

@property (nonatomic, readonly) NSMutableArray *layers;
@property (strong, nonatomic) CADLayer *drawingPen;

+ (CADLayerManager *) sharedInstance;

@end
