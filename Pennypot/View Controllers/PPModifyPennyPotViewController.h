//
//  PPAddPennyPotViewController.h
//  Pennypot
//
//  Created by Matthew Nydam on 30/11/14.
//  Copyright (c) 2014 PP. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PPPennyPot;

typedef NS_ENUM(NSInteger, PPModifyMode) {
    PPModifyModeAdd,
    PPModifyModeEdit
};

@protocol PPModifyPennyPotViewControllerDelegate <NSObject>

- (void)modifyViewControllerDidReturnPennyPot:(PPPennyPot *)pennyPot;

@end

@interface PPModifyPennyPotViewController : UIViewController

@property (nonatomic, weak) id <PPModifyPennyPotViewControllerDelegate>delegate;

- (id)initWithMode:(PPModifyMode)mode;

@end
