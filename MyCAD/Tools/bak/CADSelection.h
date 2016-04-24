//
//  CADSelectManager.h
//  MyCAD
//
//  Created by wubil on 14-4-23.
//  Copyright (c) 2014年 Autodesk. All rights reserved.
//

#import <Foundation/Foundation.h>

//@protocol CADSelectionDelegate <NSObject>
//
//@optional
//- (void)onSelectionAdded;
//- (void)onSelectionRemoveAll;
//
//@end

@interface CADSelection : NSObject<CADSelectionDelegate>

@property (nonatomic, assign) id<CADSelectionDelegate> delegate;
@property (nonatomic, strong)NSMutableArray *selectedItems;

+ (CADSelection *) sharedInstance;

- (void)add:(id)anObject;
- (void)removeAll;

@end
