//
//  PPOverviewTableViewCell.h
//  Pennypot
//
//  Created by Matthew Nydam on 19/11/14.
//  Copyright (c) 2014 PP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PPOverviewTableViewCell : UITableViewCell

- (void)configureWithModel:(NSObject *)model;

+ (NSString *)reuseIdentifier;
+ (CGFloat)heightForModel:(NSObject *)model;

@end
