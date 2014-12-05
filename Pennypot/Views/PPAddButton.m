//
//  PPAddButton.m
//  Pennypot
//
//  Created by Matthew Nydam on 1/12/14.
//  Copyright (c) 2014 PP. All rights reserved.
//

#import "PPAddButton.h"
#import "UIColor+PennyColor.h"

#import <ViewUtils/ViewUtils.h>

@interface PPAddButton ()

@property (nonatomic, strong) UIView *backgroundCircle;
@property (nonatomic, strong) UIImageView *plusImageView;

- (void)animateToSelectedState;
- (void)animateToDeselectedState;

- (void)animateShadowOn:(BOOL)shadowOn;

@end

static const CGFloat animationDuration = 0.05f;
static const CGFloat scale = 0.95f;

static const CGFloat shadowAlpha = 0.6f;

@implementation PPAddButton

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self.backgroundCircle addSubview:self.plusImageView];
        [self addSubview:self.backgroundCircle];

    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.backgroundCircle.frame = self.bounds;
    self.backgroundCircle.layer.cornerRadius = self.boundsHeight/2;
    
    self.plusImageView.center = self.backgroundCircle.center;
    
    [self.backgroundCircle.layer setShadowColor:[UIColor generalBlue].CGColor];
    [self.backgroundCircle.layer setShadowOpacity:shadowAlpha];
    [self.backgroundCircle.layer setShadowRadius:1.5f];
    [self.backgroundCircle.layer setShadowOffset:CGSizeMake(1.0, 1.0)];
}

#pragma mark - Touch Events

- (void)touchesBegan:(NSSet *)touches withEventx:(UIEvent *)event
{
    [self animateToSelectedState];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self animateToDeselectedState];
    if ([self.delegate respondsToSelector:@selector(addButtonPressed:)]) {
        [self.delegate addButtonPressed:self];
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self animateToDeselectedState];
}

#pragma mark - Animate states

- (void)animateToSelectedState
{
    [self animateShadowOn:NO];
    [UIView animateWithDuration:animationDuration animations:^{
        self.transform = CGAffineTransformMakeScale(scale, scale);
    }];
}

- (void)animateToDeselectedState
{
    [self animateShadowOn:YES];
    [UIView animateWithDuration:animationDuration animations:^{
        self.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
    }];
}

- (void)animateShadowOn:(BOOL)shadowOn
{
    CGFloat endOpacity = 0.0f;
    if (shadowOn) {
        endOpacity = shadowAlpha;
    }
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"shadowOpacity"];
    animation.fromValue = [NSNumber numberWithFloat:shadowAlpha];
    animation.toValue = [NSNumber numberWithFloat:endOpacity];
    animation.duration = animationDuration;
    [self.backgroundCircle.layer addAnimation:animation forKey:@"shadowOpacity"];
    self.backgroundCircle.layer.shadowOpacity = endOpacity;
    
}

#pragma mark - Getters

- (UIView *)backgroundCircle
{
    if (!_backgroundCircle) {
        _backgroundCircle = [UIView new];
        _backgroundCircle.backgroundColor = [UIColor generalBlue];
    }
    return _backgroundCircle;
}

- (UIImageView *)plusImageView
{
    if (!_plusImageView) {
        _plusImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"addEnabled"]];
    }
    return _plusImageView;
}



@end
