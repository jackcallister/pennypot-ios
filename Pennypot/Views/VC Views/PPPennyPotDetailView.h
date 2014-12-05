//
//  PPPennyPotDetailView.h
//  Pennypot
//
//  Created by Matthew Nydam on 5/12/14.
//  Copyright (c) 2014 PP. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PPPennyPot;

@interface PPPennyPotDetailView : UIView

- (id)initWithObject:(PPPennyPot *)object;

- (PPPennyPot *)getObjectFromFields;

@end
