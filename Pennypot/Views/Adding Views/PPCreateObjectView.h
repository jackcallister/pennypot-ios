//
//  PPCreateObjectView.h
//  Pennypot
//
//  Created by Matthew Nydam on 21/02/15.
//  Copyright (c) 2015 PP. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PPPennyPot;

@interface PPCreateObjectView : UIView

- (void)animateForEmptyTextFields;

- (BOOL)shouldDismiss;

- (void)initialResponder;
- (void)resignRespondersAndClearData;

/*
    Will return nil if the correct data does not exist.
 */
- (PPPennyPot *)retrieveObjectFromFormAnimateError;

+ (CGFloat)heightForView;

@end
