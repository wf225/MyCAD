//
//  CADToolManager.h
//  MyCAD
//
//  Created by wubil on 14-4-18.
//  Copyright (c) 2014 Feng. All rights reserved.
//

#import "CADCommand.h"

@interface CADCommandManager : NSObject<CADCommandDelegate>

@property (nonatomic, assign) id<CADCommandDelegate> delegateCommand;

@property (nonatomic, assign) CADCommandType activeCommandType;
@property (nonatomic, readonly) id<CADCommand> activeCommand;
@property (nonatomic, assign) CADShapeType drawShapeType;

+ (CADCommandManager *) sharedInstance;

@end
