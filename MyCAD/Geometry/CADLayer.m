//
//  CADLayer.m
//  MyCAD
//
//  Created by wubil on 14-4-18.
//  Copyright (c) 2014 Feng. All rights reserved.
//

#import "CADLayer.h"
#import "CADShape.h"

@implementation CADLayer

@synthesize elements = _elements;

@synthesize name = _name;
@synthesize hidden = _hidden;
@synthesize locked = _locked;
@synthesize alpha = _alpha;
@synthesize highlightColor = _highlightColor;

@synthesize strokeColor = _strokeColor;
@synthesize lineWidth = _lineWidth;

- (id) initWithName:(NSString *)layerName
{
    if (self = [super init])
    {
        _elements = [[NSMutableArray alloc] init];
        //[_elements makeObjectsPerformSelector:@selector(setLayer:) withObject:self];
        
        self.name = layerName;
        self.hidden = false;
        self.locked = false;
        self.lineWidth = kDefaultLineWidth;
        
        //self.strokeColor = [UIColor colorWithRed:kDefaultLineColor[0] green:kDefaultLineColor[1] blue:kDefaultLineColor[2] alpha:kDefaultLineColor[3]].CGColor;
        self.strokeColor = CGColorFromRGB(kDefaultLineColor[0], kDefaultLineColor[1], kDefaultLineColor[2], kDefaultLineColor[3]);
        
        self.highlightColor = self.strokeColor;
    }
    
    return self;
}

- (void) addObject:(CADShape *)obj
{
//    [[self.drawing.undoManager prepareWithInvocationTarget:self] removeObject:obj];
//    
    [_elements addObject:obj];
    //obj.layer = self;
//
//    [self invalidateThumbnail];
//    
//    if (!self.isSuppressingNotifications) {
//        NSDictionary *userInfo = @{@"layer": self,
//                                   @"rect": [NSValue valueWithCGRect:obj.styleBounds]};
//        
//        [[NSNotificationCenter defaultCenter] postNotificationName:WDLayerContentsChangedNotification
//                                                            object:self.drawing
//                                                          userInfo:userInfo];
//    }
}

- (void) addObjects:(NSArray *)objects
{
    for (CADShape *element in objects) {
        [self addObject:element];
    }
}

- (void) removeObject:(CADShape *)obj
{
//    [[self.drawing.undoManager prepareWithInvocationTarget:self] insertObject:obj atIndex:[elements_ indexOfObject:obj]];
//    
    [_elements removeObject:obj];
//    
//    [self invalidateThumbnail];
//    
//    if (!self.isSuppressingNotifications) {
//        NSDictionary *userInfo = @{@"layer": self,
//                                   @"rect": [NSValue valueWithCGRect:obj.styleBounds]};
//        
//        [[NSNotificationCenter defaultCenter] postNotificationName:WDLayerContentsChangedNotification
//                                                            object:self.drawing
//                                                          userInfo:userInfo];
//    }
}

@end
