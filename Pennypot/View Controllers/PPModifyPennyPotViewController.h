//
//  PPAddPennyPotViewController.h
//  Pennypot
//
//  Created by Matthew Nydam on 30/11/14.
//  Copyright (c) 2014 PP. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, PPModifyMode) {
    PPModifyModeAdd,
    PPModifyModeEdit
};

@interface PPModifyPennyPotViewController : UIViewController

- (id)initWithMode:(PPModifyMode)mode;

@end
