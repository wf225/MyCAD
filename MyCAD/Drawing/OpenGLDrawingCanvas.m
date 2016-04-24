//
//  GLDrawingCanvas.m
//  MyCAD
//
//  Created by wubil on 14-5-5.
//  Copyright (c) 2014 Feng. All rights reserved.
//

#import "OpenGLDrawingCanvas.h"
#import "GLDrawUtils.h"
#import "CADShape.h"
#import "CADUndoManager.h"
#import "CADCommandManager.h"

@interface OpenGLDrawingCanvas()
{
    CADUndoManager *_undoManager;
    
    // zoom
    CGAffineTransform _deviceToWorld;
    GLKMatrix4 _projectionMatrix;
    GLKMatrix4 _modelViewMatrix;
    GLint _modelViewSlot;
    
    BOOL _isPinch;
    CGFloat _previousDis; //previousDistance
    CGPoint _previousCenter;
    CGPoint _offsetVector;
}
@end

@implementation OpenGLDrawingCanvas

@synthesize shapes = _shapes;
@synthesize selection = _selection;

@synthesize worldCsOriginOffset = _worldCsOriginOffset;
@synthesize scaleFactor = _scaleFactor;

@synthesize clearColor;
@synthesize left, right, bottom, top;
@synthesize color;
@synthesize effect = _effect;


-(id)init
{
    self = [super init];
    if (self) {
        //[self onInit];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        //[self onLoad];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self onLoad];
    }
    return self;
}

- (UIView *)view
{
    return (UIView *)self;
}

- (void)onLoad
{
    self.shapes = [[NSMutableArray alloc] init];
    _effect = [[GLKBaseEffect alloc] init];
    _selection = [NSMutableArray array];
    _undoManager = [[CADUndoManager alloc] initWithCanvas:self];
    self.scaleFactor = 1.0;
    _offsetVector = CGPointMake(0, 0);

    // move the drawing origin to screen center.
    CGFloat fieldWidth = self.frame.size.width / self.scaleFactor;
    CGFloat fieldHeitht = self.frame.size.height / self.scaleFactor;
    self.worldCsOriginOffset = CGPointMake(fieldWidth/2, fieldHeitht/2);
    
    //self.zoomFactor = 5.0;
}

- (void)setWorldCsOriginOffset:(CGPoint)originOffset
{
    _worldCsOriginOffset = originOffset;
    
    CGFloat fieldWidth = self.frame.size.width / self.scaleFactor;
    CGFloat fieldHeitht = self.frame.size.height / self.scaleFactor;
    
    // viewport
    self.left = -self.worldCsOriginOffset.x;
    self.right = fieldWidth + self.left;
    self.bottom = -self.worldCsOriginOffset.y;
    self.top = fieldHeitht + self.bottom;
    
    // deviceToWorldTransform
//    _deviceToWorld = CGAffineTransformIdentity;
//    _deviceToWorld = CGAffineTransformScale(_deviceToWorld, 1, -1);
//    _deviceToWorld = CGAffineTransformTranslate(_deviceToWorld, 0, -fieldHeitht);
//    _deviceToWorld = CGAffineTransformTranslate(_deviceToWorld, -self.worldCsOriginOffset.x, self.worldCsOriginOffset.y);
}

- (void)setScaleFactor:(CGFloat)zoomFactor
{
    if (zoomFactor < 0.5 || zoomFactor > 10) {
        return;
    }
    _scaleFactor = zoomFactor;
}

- (CGPoint)deviceToWorld:(CGPoint)pt
{
    CGFloat fieldHeitht = self.frame.size.height;
    
    GLKMatrix4 viewMatrix4 = [self modelViewMatrix];
    CGAffineTransform viewTransform = CGAffineTransformMake(viewMatrix4.m00, viewMatrix4.m01, viewMatrix4.m10, viewMatrix4.m11, viewMatrix4.m30, viewMatrix4.m31);
    
    _deviceToWorld = CGAffineTransformIdentity;
    _deviceToWorld = CGAffineTransformScale(_deviceToWorld, 1, -1);
    _deviceToWorld = CGAffineTransformTranslate(_deviceToWorld, 0, -fieldHeitht);
    _deviceToWorld = CGAffineTransformTranslate(_deviceToWorld, -self.worldCsOriginOffset.x, self.worldCsOriginOffset.y);

    viewTransform = CGAffineTransformInvert(viewTransform); // invert the viewTransform.
    _deviceToWorld = CGAffineTransformConcat(_deviceToWorld, viewTransform);

    CGPoint worldPt1 = CGPointApplyAffineTransform(pt, _deviceToWorld);
    
//    CGPoint worldPt = CGPointApplyAffineTransform(pt, self.deviceToWorldTransform);
//    worldPt = CGPointMake(worldPt.x / self.zoomFactor, worldPt.y / self.zoomFactor);
    
    return worldPt1;
}

- (CGPoint)getTouchLocation:(UITouch *)touch
{
    CGPoint currentPosition = [touch locationInView:self.view];
    currentPosition = [self deviceToWorld:currentPosition];
    
    return currentPosition;
}

- (CGPoint)getTouchPreviousLocation:(UITouch *)touch
{
    CGPoint previousPosition = [touch previousLocationInView:self.view];
    previousPosition = [self deviceToWorld:previousPosition];
    return previousPosition;
}

// selection
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

#pragma mark - render

- (BOOL) isActiveCommand
{
    return [CADCommandManager sharedInstance].activeCommand != nil;
}

- (void)drawRect:(CGRect)rect
{
    [self render];
    
    if ([self isActiveCommand])
    {
        [[CADCommandManager sharedInstance].activeCommand draw:self drawMode:kDrawModeNormal];
    }
}

- (void)render
{
    // 1 clear
    glClearColor(clearColor.r, clearColor.g, clearColor.b, clearColor.a);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    // 2 effect
    _effect.transform.projectionMatrix = [self projectionMatrix];
    _effect.transform.modelviewMatrix = [self modelViewMatrix];
    
    // 3 draw
    //[self.shapes makeObjectsPerformSelector:@selector(renderInScene:) withObject:self];
    [self redraw];
    
    // draw the CS origin
    _effect.useConstantColor = YES;
    _effect.constantColor = color;
    [_effect prepareToDraw];
    GLStrokeCircle(CGPointMake(0, 0), 5, 80);
    GLStrokeLine(CGPointMake(-2, 0), CGPointMake(2, 0));
    GLStrokeLine(CGPointMake(0, -2), CGPointMake(0, 2));
}

- (void)redraw
{
    [self.shapes enumerateObjectsUsingBlock:^(CADShape *shape, NSUInteger idx, BOOL *stop)
     {
         if (shape.isSelected)
         {
             [shape glDraw:self drawMode:kDrawModeSelect];
         }
         else
         {
             [shape glDraw:self drawMode:kDrawModeNormal];
         }
     }];
}

- (GLKMatrix4)projectionMatrix
{
    _projectionMatrix = GLKMatrix4MakeOrtho(left, right, bottom, top, 1, -1);
    return _projectionMatrix;
}

- (GLKMatrix4)modelViewMatrix
{
    _modelViewMatrix = GLKMatrix4Identity;
    _modelViewMatrix = GLKMatrix4Translate(_modelViewMatrix, _offsetVector.x, _offsetVector.y, 0);
    //_modelViewMatrix = GLKMatrix4Rotate(_modelViewMatrix, self.rotateX, 1.0, 0.0, 0.0);
    _modelViewMatrix = GLKMatrix4Scale(_modelViewMatrix, _scaleFactor, _scaleFactor, 0);
    //glUniformMatrix4fv(_modelViewSlot, 1, GL_FALSE, &_modelViewMatrix.m00);
    
    return _modelViewMatrix;
}

- (void)renderSamples
{
    // 1 TRIANGLES
    float vertices[] = {
        -100, -200,
        100, -200,
        0,  0};
    
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 2, GL_FLOAT, GL_FALSE, 0, vertices);
    glDrawArrays(GL_TRIANGLES, 0, 3);
    glDisableVertexAttribArray(GLKVertexAttribPosition);
    
    // 2 effect
//    GLKBaseEffect *effect = [[GLKBaseEffect alloc] init];
//    effect.transform.projectionMatrix = GLKMatrix4MakeOrtho(left, right, bottom, top, 1, -1);
//    // add color
//    effect.useConstantColor = YES;
//    effect.constantColor = color;
//    [effect prepareToDraw];
//    glLineWidth(3); // line width
    
    //4
    GLFillCircle(CGPointMake(0, 0), 384, 80);
    
    // change color
    _effect.constantColor = GLKVector4Make(0, 0, 1, 0.0);;
    [_effect prepareToDraw];
    
    GLStrokeRect(CGRectMake(-300, -300, 600, 600));
    GLStrokeCircle(CGPointMake(0, 0), 300, 80);
    
    // line width
    glLineWidth(20);
    GLStrokeLine(CGPointMake(-300, -300), CGPointMake(300, 300));
    glLineWidth(3);
    
    // change color
    _effect.constantColor = GLKVector4Make(0, 1, 0, 0.0);;
    [_effect prepareToDraw];
    
    GLFillRect(CGRectMake(-100, -100, 200, 200));
}

#pragma mark - Touch Methods

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    _isPinch = NO;
    if (event.allTouches.count == 1)
    {
        [[CADCommandManager sharedInstance].activeCommand touchesBegan:touches withEvent:event view:self];
    }
    else if (event.allTouches.count == 2)
    {
        [self pinchBegan:[event.allTouches allObjects]];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (event.allTouches.count == 1)
    {
        [[CADCommandManager sharedInstance].activeCommand touchesMoved:touches withEvent:event view:self];
    }
    else if (event.allTouches.count == 2 && _isPinch == NO)
    {
        [self pinchBegan:[event.allTouches allObjects]];
    }
    else if (event.allTouches.count == 2 && _isPinch == YES)
    {
        [self pinching:[event.allTouches allObjects]];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (event.allTouches.count == 1)
    {
        [[CADCommandManager sharedInstance].activeCommand touchesEnded:touches withEvent:event view:self];
    }
    else if (event.allTouches.count == 2 && _isPinch == YES)
    {
        [self pinchEnded:[event.allTouches allObjects]];
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[CADCommandManager sharedInstance].activeCommand touchesCancelled:touches withEvent:event view:self];
}

// Pinch
- (void)pinchBegan:(NSArray *)touches
{
    _isPinch = YES;

    CGPoint pt1 = [[touches objectAtIndex:0] locationInView:self];
    CGPoint pt2 = [[touches objectAtIndex:1] locationInView:self];
    pt1 = [self deviceToWorld:pt1];
    pt2 = [self deviceToWorld:pt2];
    
    _previousDis = CADPointsDistance(pt1, pt2);
    _previousCenter = CADPointsCenter(pt1, pt2);
}

- (void)pinching:(NSArray *)touches
{
    CGPoint pt1 = [[touches objectAtIndex:0] locationInView:self];
    CGPoint pt2 = [[touches objectAtIndex:1] locationInView:self];
    pt1 = [self deviceToWorld:pt1];
    pt2 = [self deviceToWorld:pt2];
    
    CGFloat distance = CADPointsDistance(pt1, pt2);
    CGPoint center = CADPointsCenter(pt1, pt2);
    
    // scale
    self.scaleFactor += (distance - _previousDis) / _previousDis;
    //NSLog(@"zoomFactor:(%f", _scaleFactor);
    
    // pan
    CGPoint offsetIncrement = CADPointMinus(center, _previousCenter);
    _offsetVector = CADPointPlus(_offsetVector, offsetIncrement);
    
    _previousDis = distance;
    _previousCenter = center;
    
    [self setNeedsDisplay];
}

- (void)pinchEnded:(NSArray *)touches
{
    _isPinch = NO;
    _previousDis = 0.0f;
    _previousCenter = CGPointZero;
}

#pragma mark - Gesture Recognizer

- (void)registerGestureRecognizer
{
    // sigle Tap
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onSingleTap:)];
    singleTap.numberOfTapsRequired = 1; // sigle click
    [self addGestureRecognizer:singleTap];
}

- (void)onSingleTap:(UITapGestureRecognizer *)gestureRecognizer
{
    UIView *view = [gestureRecognizer view]; // get the gesture owner view.
    CGPoint currentPoint = [gestureRecognizer locationInView:view];
    NSLog(@"tapPoint-DeviceCS:(%f, %f)", currentPoint.x, currentPoint.y);
    
    // convert to world CS
    currentPoint = [self deviceToWorld:currentPoint];
    NSLog(@"tapPoint-WorldCS:(%f, %f)", currentPoint.x, currentPoint.y);
    
    for (CADShape *element in self.shapes)
    {
        if([element hitTest:self point:currentPoint]
           && self.selectionCount == 0) // TODO: support multip selection in future.
        {
            element.isSelected = true;
            [element glDraw:self drawMode:kDrawModeSelect];
        }
        else
        {
            element.isSelected = false;
            [element glDraw:self drawMode:kDrawModeNormal];
        }
    }
    
    [self setNeedsDisplay];
    
    // NOTE: raise selection change event.
    [self.delegateSelection onSelectioinChanged:self.selection];
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
