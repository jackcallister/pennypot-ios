//
//  PPAddPennyPotViewController.h
//  Pennypot
//
//  Created by Matthew Nydam on 30/11/14.
//  Copyright (c) 2014 PP. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PPPennyPot;

@protocol PPModifyPennyPotViewControllerDelegate <NSObject>

- (void)modifyViewControllerDidReturnPennyPot:(PPPennyPot *)pennyPot;

@end

@interface PPModifyPennyPotViewController : UIViewController

@property (nonatomic, weak) id <PPModifyPennyPotViewControllerDelegate>delegate;

@property (nonatomic, strong) UIImage *backingImage;

- (instancetype)initWithObject:(PPPennyPot *)object;

@end
