//
//  PPAnimator.h
//  Pennypot
//
//  Created by Matthew Nydam on 16/03/15.
//  Copyright (c) 2015 PP. All rights reserved.
//

#import <UIKit/UIKit.h>

// Need better names :(
typedef enum {
    PPAnimatorPresentationTypePresent,
    PPAnimatorPresentationTypeDismiss
} PPAnimatorPresentationType;

@interface PPAnimator : NSObject <UIViewControllerAnimatedTransitioning>

- (id)initWithPresentationType:(PPAnimatorPresentationType)presentationType;

@end
