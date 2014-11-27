//
//  PPOverviewTableViewCell.h
//  Pennypot
//
//  Created by Matthew Nydam on 19/11/14.
//  Copyright (c) 2014 PP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MCSwipeTableViewCell/MCSwipeTableViewCell.h>

@class PPPennyPot;

@interface PPOverviewTableViewCell : MCSwipeTableViewCell

- (void)configureWithModel:(PPPennyPot *)model;

+ (NSString *)reuseIdentifier;
+ (CGFloat)heightForModel:(NSObject *)model;

@end
