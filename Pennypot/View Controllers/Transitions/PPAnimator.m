//
//  PPAnimator.m
//  Pennypot
//
//  Created by Matthew Nydam on 16/03/15.
//  Copyright (c) 2015 PP. All rights reserved.
//

#import "PPAnimator.h"
#import <ViewUtils/ViewUtils.h>

@interface PPAnimator ()

@property (nonatomic) PPAnimatorPresentationType presentationType;

@end

@implementation PPAnimator

- (id)initWithPresentationType:(PPAnimatorPresentationType)presentationType
{
    if (self = [super init]) {
        self.presentationType = presentationType;
    }
    return self;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    [[transitionContext containerView] addSubview:toViewController.view];
    
    if (self.presentationType == PPAnimatorPresentationTypePresent) {
        toViewController.view.right = 0;
    } else {
        toViewController.view.left = fromViewController.view.right;
    }
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.0f usingSpringWithDamping:0.8f initialSpringVelocity:1.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        if (self.presentationType == PPAnimatorPresentationTypePresent) {
            toViewController.view.right = fromViewController.view.right;
            fromViewController.view.left = 20;
        } else {
            toViewController.view.left = 0;
            fromViewController.view.right = fromViewController.view.right - 20;
        }
        
    } completion:^(BOOL finished) {
        
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
    return 0.40f;
}

@end
