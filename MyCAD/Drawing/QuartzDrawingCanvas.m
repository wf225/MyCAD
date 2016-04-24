//
//  DrawingCanvas.h
//  MyCAD
//
//  Created by wubil on 14-4-14.
//  Copyright (c) 2014 Feng. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "QuartzDrawingCanvas.h"
#import "CADShape.h"
#import "CADLayer.h"
#import "CADUndoManager.h"
#import "CADDrawCommand.h"
#import "CADCommandManager.h"
#import "CADMoveCommand.h"

NSString *CADCanvasBeganTrackingTouches = @"WDCanvasBeganTrackingTouches";

@interface QuartzDrawingCanvas()
{
    CGAffineTransform _coordinateTransform;
    CADUndoManager *_undoManager;
    
    // zoom
    BOOL _isPinch;
    CGFloat _previousDis; //previousDistance
    CGFloat _zoomFactor;
}
@end

#pragma mark - implementation DrawingView

@implementation QuartzDrawingCanvas

@synthesize image = _image;
@synthesize shapes = _shapes;
@synthesize selection = _selection;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self onInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self onInit];
    }
    return self;
}

- (UIView *)view
{
    return (UIView *)self;
}

- (void)onInit
{
    // init the private arrays
    self.shapes = [NSMutableArray array];
    _selection = [NSMutableArray array];
    _undoManager = [[CADUndoManager alloc] initWithCanvas:self];
    
    // set the transparent background
    self.backgroundColor = [UIColor clearColor]; // [UIColor clearColor];
    
    // NOTE: reset coordinate.
    // 原坐标系为Quartz 2D绘图坐标系(X轴正方向向右,Y轴正方向向上),目标坐标系为 UKit坐标系(X轴正方向向右,Y轴正方向向下),
    // 用原坐标系中坐标绘图
    _coordinateTransform = CGAffineTransformIdentity;
    //transform = CGAffineTransformTranslate(transform, 0, self.bounds.size.height);
    _coordinateTransform = CGAffineTransformScale(_coordinateTransform, 1, -1);
    [self setTransform:_coordinateTransform];
    
    // zoom
    _isPinch = NO;
    _previousDis = 0.0f;
    _zoomFactor = 1.0f;
}

- (CGPoint)getTouchLocation:(UITouch *)touch
{
    CGPoint currentPosition = [touch locationInView:self.view];
    //currentPosition = [self deviceToWorld:currentPosition];
    
    return currentPosition;
}

- (CGPoint)getTouchPreviousLocation:(UITouch *)touch
{
    CGPoint previousPosition = [touch previousLocationInView:self.view];
    //previousPosition = [self deviceToWorld:previousPosition];
    return previousPosition;
}

- (NSMutableArray *)selection
{
    [_selection removeAllObjects];
    
    for (CADShape *element in self.shapes) {
        if (element.isSelected) {
            [_selection addObject:element];
        }
    }
    
    return _selection;
}

- (int)selectionCount
{
    int count = 0;
    for (CADShape *element in self.shapes) {
        if (element.isSelected) {
            count++;
        }
    }
    return count;
}

#pragma mark - Drawing

- (CGContextRef)drawContext
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    return context;
}

- (void)drawRect:(CGRect)rect
{
    [self.image drawInRect:self.bounds];
    
    if ([self isActiveCommand])
    {
        [[CADCommandManager sharedInstance].activeCommand draw:self drawMode:kDrawModeNormal];
        //[self refreshCanvasWithCommand:[CADCommandManager sharedInstance].activeCommand];
    }
}

- (void)refreshCanvasWithCommand:(id<CADCommand>)command
{
    // 1. begin a context
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0.0);
    
    // 2.
    [self.image drawAtPoint:CGPointZero]; // NOTE: for append element, set the draw point
    [command draw:self drawMode:kDrawModeNormal];
    
    // 3. refresh the update to screen.
    self.image = UIGraphicsGetImageFromCurrentImageContext();
    // 4. end a context
    UIGraphicsEndImageContext();
}

- (void)redraw
{
    // 1. begin a context
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClearRect(context, self.bounds); // clear context
    
    // redraw all the elements
    for (CADShape *element in self.shapes)
    {
        if (element.isSelected)
        {
            [element draw:self drawMode:kDrawModeSelect];
        }
        else
        {
            [element draw:self drawMode:kDrawModeNormal];
        }
    }
    
    
    // 3. refresh the update to screen.
    self.image = nil; // erase the previous image
    [self.image drawAtPoint:CGPointZero]; // set the draw point
    self.image = UIGraphicsGetImageFromCurrentImageContext();
    
    // 4. end a context
    UIGraphicsEndImageContext();
    
    [self setNeedsDisplay];
}

#pragma mark - Touch Methods

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    _isPinch = NO;
    if (event.allTouches.count == 1)
    {
        [[CADCommandManager sharedInstance].activeCommand touchesBegan:touches withEvent:event view:self];
        
        // call the delegate
        if ([self.delegateCanvas respondsToSelector:@selector(drawingCanvas:willBeginDrawing:)])
        {
            [self.delegateCanvas drawingCanvas:self willBeginDrawing:[CADCommandManager sharedInstance].activeCommand];
        }
    }
    else if (event.allTouches.count == 2)
    {
        _isPinch = YES;
        NSArray *touches = [event.allTouches allObjects];
        CGPoint pointOne = [[touches objectAtIndex:0] locationInView:self];
        CGPoint pointTwo = [[touches objectAtIndex:1] locationInView:self];
        _previousDis = CADPointsDistance(pointOne, pointTwo);
    }
    
    //[[NSNotificationCenter defaultCenter] postNotificationName:CADCanvasBeganTrackingTouches object:self];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touchesMoved");
    
    if (event.allTouches.count == 1)
    {
        [[CADCommandManager sharedInstance].activeCommand touchesMoved:touches withEvent:event view:self];
    }
    else if (event.allTouches.count == 2 && _isPinch == YES)
    {
        NSArray *touches = [event.allTouches allObjects];
        CGPoint pointOne = [[touches objectAtIndex:0] locationInView:self];
        CGPoint pointTwo = [[touches objectAtIndex:1] locationInView:self];
        CGFloat distance = CADPointsDistance(pointOne, pointTwo);
        _zoomFactor += (distance - _previousDis) / _previousDis;
        _zoomFactor = fabs(_zoomFactor);
        _previousDis = distance;
        
        //if (zoomFactor > 1)
        {
            CGAffineTransform zoomTransform = CGAffineTransformIdentity;
            
            CGPoint boundCenter = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
            CGPoint frameCenter = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
            CGPoint tPoint = CADPointMinus(boundCenter, frameCenter);
            zoomTransform = CGAffineTransformTranslate(zoomTransform, tPoint.x, tPoint.y);
            
            //NSLog(@"bounds=(%f,%f,%f,%f) center=(%f,%f)", self.bounds.origin.x, self.bounds.origin.y, self.bounds.size.width, self.bounds.size.height, boundCenter.x, boundCenter.y);
            NSLog(@"frame=(%f,%f,%f,%f) center=(%f,%f", self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height, frameCenter.x, frameCenter.y);
            
            zoomTransform = CGAffineTransformScale(zoomTransform, _zoomFactor, -_zoomFactor);
            //[self setTransform:zoomTransform];
        }
    }
    else if (event.allTouches.count == 2 && _isPinch == NO)
    {
        _isPinch = YES;
        NSArray *touches = [event.allTouches allObjects];
        CGPoint pointOne = [[touches objectAtIndex:0] locationInView:self];
        CGPoint pointTwo = [[touches objectAtIndex:1] locationInView:self];
        _previousDis = CADPointsDistance(pointOne, pointTwo);
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (event.allTouches.count == 1)
    {
        [[CADCommandManager sharedInstance].activeCommand touchesEnded:touches withEvent:event view:self];
        
        // call the delegate
        if ([self.delegateCanvas respondsToSelector:@selector(drawingCanvas:didEndDrawing:)])
        {
            [self.delegateCanvas drawingCanvas:self didEndDrawing:[CADCommandManager sharedInstance].activeCommand];
        }
    }
    else if (event.allTouches.count == 2)
    {
        _isPinch = NO;
        _previousDis = 0.0f;
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[CADCommandManager sharedInstance].activeCommand touchesCancelled:touches withEvent:event view:self];
}

//
- (BOOL) isDrawCommand
{
    return [[CADCommandManager sharedInstance].activeCommand isKindOfClass:[CADDrawCommand class]];
}

- (BOOL) isMoveCommand
{
    return [[CADCommandManager sharedInstance].activeCommand isKindOfClass:[CADMoveCommand class]];
}

- (BOOL) isActiveCommand
{
    return [CADCommandManager sharedInstance].activeCommand != nil;
}


#pragma mark - Gesture Recognizer

- (void)registerGestureRecognizer
{
    // sigle Tap
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapHandler:)];
    singleTap.numberOfTapsRequired = 1; // sigle click
    [self addGestureRecognizer:singleTap];
    
    // double Tap
    UITapGestureRecognizer* doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapHandler:)];
    doubleTap.numberOfTapsRequired = 2; // double click
    [self addGestureRecognizer:doubleTap];
    
    // 关键在这一行，如果双击确定偵測失败才會触发单击
    [singleTap requireGestureRecognizerToFail:doubleTap];
    
    // pan
//    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panHandler:)];
//    [self addGestureRecognizer:panGesture];
    
    // pinch: 用户触控屏幕上的两点，然后聚合或分开两点。收缩行为与两个手指拖动类似。启用手势操作之后，当两个手指按下时，此手势操作优先于拖动手势。
    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchHandler:)];
    [self addGestureRecognizer:pinchGesture];
}

- (void)singleTapHandler:(UITapGestureRecognizer *)gestureRecognizer
{
    UIView *view = [gestureRecognizer view]; // get the gesture owner view.
    CGPoint currentPoint = [gestureRecognizer locationInView:view];
    
    // erase the previous image
    self.image = nil;
    [self.image drawInRect:self.bounds];
    
    // init a context
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // clear context
    CGContextClearRect(context, self.bounds);
    
    for (CADShape *element in self.shapes)
    {
        if([element hitTest:self point:currentPoint]
           && self.selectionCount == 0) // TODO: support multip selection in future.
        {
            element.isSelected = true;
            [element draw:self drawMode:kDrawModeSelect];
        }
        else
        {
            element.isSelected = false;
            [element draw:self drawMode:kDrawModeNormal];
        }
    }
    
    // store the image
    self.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [self setNeedsDisplay];
    
    // NOTE: raise selection change event.
    [self.delegateSelection onSelectioinChanged:self.selection];
}

- (void)doubleTapHandler:(UITapGestureRecognizer *)gestureRecognizer
{
    NSLog(@"Gesture: DoubleTap");
}

- (void)panHandler:(UIPanGestureRecognizer *)gestureRecognizer
{
    NSLog(@"Gesture: Pan");
}

- (void)pinchHandler:(UIPinchGestureRecognizer *)gestureRecognizer
{
    NSLog(@"Gesture: Pinch");
}

#pragma mark - Actions

- (void)clear
{
    [self.shapes removeAllObjects];
    [_undoManager clearHistory];
    
    [self redraw];
    [self setNeedsDisplay];
}

#pragma mark - Undo / Redo

- (BOOL)canUndo
{
    return _undoManager.canUndo;
}

- (void)undoLatestStep
{
    [_undoManager undo];
}

- (BOOL)canRedo
{
    return  _undoManager.canRedo;
}

- (void)redoLatestStep
{
    [_undoManager redo];
}

- (void)addCommandToHistory:(id<CADCommand>)command
{
    [_undoManager addCommandToHistory:command];
}

@end
