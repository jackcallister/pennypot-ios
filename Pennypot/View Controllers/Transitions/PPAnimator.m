//
//  PPAnimator.m
//  Pennypot
//
//  Created by Matthew Nydam on 16/03/15.
//  Copyright (c) 2015 PP. All rights reserved.
//

#import "PPAnimator.h"
#import "PPOverviewTableViewController.h"
#import "PPModifyPennyPotViewController.h"
#import <ViewUtils/ViewUtils.h>

@interface PPAnimator ()

@property (nonatomic) PPAnimatorPresentation presentationType;

@end

static const CGFloat bottomViewOffset = 30.0f;

@implementation PPAnimator

- (id)initWithPresentationType:(PPAnimatorPresentation)presentationType
{
    if (self = [super init]) {
        self.presentationType = presentationType;
    }
    return self;
}

#pragma mark - Transitions

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    [[transitionContext containerView] addSubview:toViewController.view];
    
    if (self.presentationType == PPAnimatorPresentationPresent) {

        if ([fromViewController isKindOfClass:[PPOverviewTableViewController class]]) {            
            ((PPModifyPennyPotViewController *)toViewController).backingImage = [self screenShotOfView:fromViewController.view];
        }
        
        toViewController.view.top = fromViewController.view.bottom;
        
    } else {
        
        toViewController.view.top -= bottomViewOffset;
        
        [[transitionContext containerView] sendSubviewToBack:toViewController.view];
    }
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.0f usingSpringWithDamping:0.8f initialSpringVelocity:1.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        if (self.presentationType == PPAnimatorPresentationPresent) {
            toViewController.view.top = 0;
            fromViewController.view.bottom -= bottomViewOffset;
        } else {
            toViewController.view.top += bottomViewOffset;
            fromViewController.view.top = toViewController.view.bottom;
        }
        
    } completion:^(BOOL finished) {

        if (self.presentationType == PPAnimatorPresentationPresent) {
            fromViewController.view.bottom += 30;
        }
        
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        
    }];
}

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
    return 0.40f;
}

#pragma mark - Util

- (UIImage *)screenShotOfView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.frame.size, YES, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:context];
    UIImage *capturedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return capturedImage;
}

@end
