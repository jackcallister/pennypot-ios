//
//  PPAnimatingAddCancelIcon.m
//  Pennypot
//
//  Created by Matthew Nydam on 22/02/15.
//  Copyright (c) 2015 PP. All rights reserved.
//

#import "PPAnimatingAddControl.h"
#import "PPObjectCreationNotificationManager.h"
#import <ViewUtils/ViewUtils.h>

#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)

@interface PPAnimatingAddControl ()

@property (nonatomic) BOOL isCancelling;

@property (nonatomic, strong) UIView *containingView;
@property (nonatomic, strong) CAShapeLayer *verticalLine;
@property (nonatomic, strong) CAShapeLayer *horizontalLine;

- (void)createShapeLayers;

- (IBAction)animateToState:(id)sender;

@end

static const CGFloat lineWidth = 1.0f;

@implementation PPAnimatingAddControl

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [PPObjectCreationNotificationManager registerForStateChangedNotificationWithObserver:self andStateChangeSelector:@selector(animateToState:)];
        self.backgroundColor = [UIColor clearColor];
        
        [self addTarget:self action:@selector(buttonWasPressed) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.containingView];
        [self.containingView.layer addSublayer:self.verticalLine];
        [self.containingView.layer addSublayer:self.horizontalLine];
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (!self.isCancelling) {
        self.containingView.width = self.containingView.height = 25.0f;
        
        self.containingView.left = self.boundsWidth/2 - self.containingView.width/2;
        self.containingView.top = self.boundsHeight/2 - self.containingView.height/2;
    }

    
    [self createShapeLayers];
}

- (void)createShapeLayers
{
    self.verticalLine.path = [UIBezierPath bezierPathWithRect: CGRectMake(self.containingView.boundsWidth/2 - (lineWidth/2), 0, lineWidth, self.containingView.boundsHeight)].CGPath;

    self.horizontalLine.path = [UIBezierPath bezierPathWithRect: CGRectMake(0, self.containingView.boundsHeight/2 - (lineWidth/2), self.containingView.boundsWidth, lineWidth)].CGPath;

    self.verticalLine.strokeColor = self.verticalLine.fillColor= [UIColor whiteColor].CGColor;
    self.horizontalLine.strokeColor = self.horizontalLine.fillColor = [UIColor whiteColor].CGColor;
}

- (void)dealloc
{
    [PPObjectCreationNotificationManager deregisterForStateChangedNotificationWithObserver:self];
}

#pragma mark - Actions

- (void)buttonWasPressed
{
    [PPObjectCreationNotificationManager sendStateChangedNotificationWithUIChangeIntention:YES];
}

- (void)animateToState:(NSNotification *)sender
{
    BOOL notificationOriginatedFromCross = [[sender object] boolValue];
    
    if (!notificationOriginatedFromCross) {
        return;
    }
    
    self.isCancelling = !self.isCancelling;

    CGFloat radiansToRotate = DEGREES_TO_RADIANS(135);
    
    [UIView animateWithDuration:0.5f delay:0.0f usingSpringWithDamping:0.6f initialSpringVelocity:0.6f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        if (self.isCancelling) {
            self.containingView.transform = CGAffineTransformMakeRotation(radiansToRotate);
            
        } else {
            self.containingView.transform = CGAffineTransformIdentity;
        }

    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark - Getters

- (UIView *)containingView
{
    if (!_containingView) {
        _containingView = [UIView new];
        [_containingView setUserInteractionEnabled:NO];
    }
    return _containingView;
}

- (CAShapeLayer *)verticalLine
{
    if (!_verticalLine) {
        _verticalLine = [CAShapeLayer new];
    }
    return _verticalLine;
}

- (CAShapeLayer *)horizontalLine
{
    if (!_horizontalLine) {
        _horizontalLine = [CAShapeLayer new];
    }
    return _horizontalLine;
}

@end
