//
//  PPOverviewTableViewCell.m
//  Pennypot
//
//  Created by Matthew Nydam on 19/11/14.
//  Copyright (c) 2014 PP. All rights reserved.
//

#import "PPOverviewTableViewCell.h"

@implementation PPOverviewTableViewCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
    }
    return self;
}

- (void)configureWithModel:(NSObject *)model
{
    self.contentView.backgroundColor = [[UIColor purpleColor]colorWithAlphaComponent:0.3f];
}

#pragma mark - Getter

#pragma mark - Class

+ (NSString *)reuseIdentifier
{
    return @"PPOverviewTableViewCell";
}

+ (CGFloat)heightForModel:(NSObject *)model
{
    return 60.0f;
}


@end
