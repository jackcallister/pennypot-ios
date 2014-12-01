//
//  PPAddButton.h
//  Pennypot
//
//  Created by Matthew Nydam on 1/12/14.
//  Copyright (c) 2014 PP. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PPAddButton;

@protocol PPAddButtonDelegate <NSObject>

- (void)addButtonPressed:(PPAddButton *)button;

@end

@interface PPAddButton : UIView

@property (nonatomic, weak) id<PPAddButtonDelegate> delegate;

@end
