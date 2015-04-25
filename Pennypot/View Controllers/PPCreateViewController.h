//
//  PPCreateViewController.h
//  Pennypot
//
//  Created by Matt Nydam on 11/04/15.
//  Copyright (c) 2015 PP. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PPPennyPot;
@class PPCreateViewController;

@protocol PPCreateViewControllerDelegate <NSObject>

@optional
-(void)createViewController:(PPCreateViewController *)viewController didCreateObject:(PPPennyPot *)object;

@end

@interface PPCreateViewController : UIViewController

@property(nonatomic,weak)id< PPCreateViewControllerDelegate> delegate;

@end
