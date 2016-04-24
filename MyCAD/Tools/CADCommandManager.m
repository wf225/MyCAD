//
//  CADToolManager.m
//  MyCAD
//
//  Created by wubil on 14-4-18.
//  Copyright (c) 2014 Feng. All rights reserved.
//

#import "CADCommandManager.h"
#import "CADCommand.h"
#import "CADDrawCommand.h"
#import "CADMoveCommand.h"
#import "CADRotateCommand.h"
#import "CADScaleCommand.h"

NSString *CADActiveToolDidChange = @"CADActiveToolDidChange";

@implementation CADCommandManager

@synthesize activeCommandType = _activeCommandType;
@synthesize activeCommand = _activeCommand;
@synthesize drawShapeType = _drawShapeType;

+ (CADCommandManager *) sharedInstance
{
    static CADCommandManager *commandManager = nil;
    
    if (!commandManager) {
        commandManager = [[CADCommandManager alloc] init];
    }
    
    return commandManager;
}

- (void) setActiveCommandType:(CADCommandType)commandType
{
    _activeCommandType = commandType;
    
    switch (_activeCommandType) {
        case kDrawCommand:
            _activeCommand = [CADDrawCommand create];
            break;
        case kMoveCommand:
            _activeCommand = [CADMoveCommand create];
            break;
        case kRotateComand:
            _activeCommand = [CADRotateCommand create];
            break;
        case kScaleCommand:
            _activeCommand = [CADScaleCommand create];
            break;
        case kNullCommand:
        default:
            _activeCommand.delegateCommand = nil;
            _activeCommand = nil;
    }
    
    if (_activeCommand != nil) {
        _activeCommand.delegateCommand = self;
    }
}

- (void)onCommandEnd
{
    [self.delegateCommand onCommandEnd];
    
    // NOTE: clear the activeCommand when touch ended
    [CADCommandManager sharedInstance].activeCommandType = kNullCommand;
}

@end
