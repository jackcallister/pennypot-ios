//
//  PPOverviewTableViewCell.h
//  Pennypot
//
//  Created by Matthew Nydam on 19/11/14.
//  Copyright (c) 2014 PP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MCSwipeTableViewCell/MCSwipeTableViewCell.h>

@class PPOverviewTableViewCell;
@class PPPennyPot;

@protocol PPOverviewTableViewCellDelegate <NSObject>

- (void)overviewTableViewCell:(PPOverviewTableViewCell *)cell didSwipeWithCellMode:(MCSwipeTableViewCellMode)mode;

@end

@interface PPOverviewTableViewCell : MCSwipeTableViewCell

@property (nonatomic, strong) PPPennyPot *pennyPot;
@property (nonatomic, assign) id<PPOverviewTableViewCellDelegate>delegate;

- (void)configureWithModel:(PPPennyPot *)model;

+ (NSString *)reuseIdentifier;
+ (CGFloat)heightForModel:(NSObject *)model;

@end
