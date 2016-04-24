//
//  CADSelectManager.m
//  MyCAD
//
//  Created by wubil on 14-4-23.
//  Copyright (c) 2014年 Autodesk. All rights reserved.
//

#import "CADSelection.h"
#import "CADMainToolbar.h"
#import "CADEditToolbar.h"

@implementation CADSelection
@synthesize selectedItems = _selectedItems;

+ (CADSelection *) sharedInstance
{
    static CADSelection *selectManager = nil;
    
    if (!selectManager) {
        selectManager = [[CADSelection alloc] init];
    }
    
    return selectManager;
}

- (id)init
{
    self = [super init];
    if (self != nil)
    {
        self.selectedItems = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)add:(id)anObject
{
    [self.selectedItems addObject:anObject];
    
    [self.delegate onSelectionAdded];
}

- (void)removeAll
{
    [self.delegate onSelectionRemoveAll];
    
    [self.selectedItems removeAllObjects];
}

@end
