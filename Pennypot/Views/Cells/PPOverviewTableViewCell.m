//
//  PPOverviewTableViewCell.m
//  Pennypot
//
//  Created by Matthew Nydam on 19/11/14.
//  Copyright (c) 2014 PP. All rights reserved.
//
#import "PPOverviewTableViewCell.h"
#import "PPPennyPot.h"

#import <ViewUtils/ViewUtils.h>


@interface PPOverviewTableViewCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *progressLabel;

@property (nonatomic, strong) UIView *fullProgressBar;
@property (nonatomic, strong) UIView *currentProgressBar;

@end

static const CGFloat kVerticalPadding = 10.0f;
static const CGFloat kHorizontalPadding = 20.0f;

@implementation PPOverviewTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.fullProgressBar];
        [self.contentView addSubview:self.currentProgressBar];
        
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.progressLabel];
    }
    return self;
}

- (void)configureWithModel:(PPPennyPot *)model
{
    self.titleLabel.text = model.title;
    self.progressLabel.text = @"$1900 of $2000";
    
    [self.titleLabel sizeToFit];
    [self.progressLabel sizeToFit];
}

#pragma mark - Layout

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.titleLabel.left = kHorizontalPadding;
    self.progressLabel.right = self.boundsWidth - kHorizontalPadding;
    
    self.progressLabel.top = self.titleLabel.top = kVerticalPadding;
    
    self.currentProgressBar.height = self.fullProgressBar.height = 3;
    self.currentProgressBar.width = self.contentView.boundsWidth - (kHorizontalPadding * 2);
    self.currentProgressBar.left = self.fullProgressBar.left = kHorizontalPadding;
    self.currentProgressBar.bottom = self.fullProgressBar.bottom = self.contentView.bottom - kVerticalPadding;
    
    self.fullProgressBar.layer.cornerRadius = self.currentProgressBar.layer.cornerRadius = self.fullProgressBar.height/2;
}

#pragma mark - Getters

- (UIView *)fullProgressBar
{
    if (!_fullProgressBar) {
        _fullProgressBar = [UIView new];
        
        _fullProgressBar.backgroundColor = [UIColor redColor];
    }
    return _fullProgressBar;
}

- (UIView *)currentProgressBar
{
    if (!_currentProgressBar) {
        _currentProgressBar = [UIView new];
        _currentProgressBar.backgroundColor = [UIColor purpleColor];
    }
    return _currentProgressBar;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
    }
    return _titleLabel;
}

- (UILabel *)progressLabel
{
    if (!_progressLabel) {
        _progressLabel = [UILabel new];
    }
    return _progressLabel;
}

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
