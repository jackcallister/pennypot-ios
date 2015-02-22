//
//  PPAnimatingAddCancelIcon.m
//  Pennypot
//
//  Created by Matthew Nydam on 22/02/15.
//  Copyright (c) 2015 PP. All rights reserved.
//

#import "PPAnimatingAddControl.h"

#import <ViewUtils/ViewUtils.h>

@interface PPAnimatingAddControl ()

@property (nonatomic, strong) UIBezierPath *verticalLine;
@property (nonatomic, strong) UIBezierPath *horizontalLine;
@end

static const CGFloat lineWidth = 2.0f;

@implementation PPAnimatingAddControl

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        [self addTarget:self action:@selector(animateToState:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}


- (void)drawRect:(CGRect)rect
{
    
    UIColor *fillColor = [UIColor whiteColor];
    
    //// Rectangle Drawing
    self.verticalLine = [UIBezierPath bezierPathWithRect: CGRectMake(self.boundsWidth/2 - (lineWidth/2), 0, lineWidth, self.boundsHeight)];
    [fillColor setFill];
    [self.verticalLine fill];
    
    
    //// Rectangle 2 Drawing
    self.horizontalLine = [UIBezierPath bezierPathWithRect: CGRectMake(0, self.boundsHeight/2 - (lineWidth/2), self.boundsWidth, lineWidth)];
    [fillColor setFill];
    [self.horizontalLine fill];
}

#pragma mark - Actions

- (IBAction)animateToState:(id)sender
{
//    CGAffineTransform transform = CGAffineTransformMakeRotation(0.7853981634);
//    [self.verticalLine applyTransform: transform];
}


@end
