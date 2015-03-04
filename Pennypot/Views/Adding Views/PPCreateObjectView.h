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

@property (nonatomic, strong) UIButton *confirmButton;

- (void)animateForEmptyTextFields;

- (BOOL)shouldDismiss;

- (void)initialResponder;
- (void)resignRespondersAndClearData;

- (PPPennyPot *)retrieveObjectFromForm;

+ (CGFloat)heightForView;

@end
