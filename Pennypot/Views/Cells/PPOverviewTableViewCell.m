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
#import "UIColor+PennyColor.h"


@interface PPOverviewTableViewCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *progressLabel;

@property (nonatomic, strong) UIView *fullProgressBar;
@property (nonatomic, strong) UIView *currentProgressBar;

@property (nonatomic, strong) UIImageView *coinView;
@property (nonatomic, strong) UIImageView *trashView;

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
    self.pennyPot = model;
    self.titleLabel.text = self.pennyPot.title;
    self.progressLabel.text = @"$1900 of $2000";
    
    self.currentProgressBar.backgroundColor = [UIColor purpleColor];
    
    [self.titleLabel sizeToFit];
    [self.progressLabel sizeToFit];
    
    
    [self addSwipeInteractions];
}

#pragma mark - Layout

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat maxWidth = self.contentView.boundsWidth - (kHorizontalPadding * 2);
    
    self.titleLabel.left = kHorizontalPadding;
    self.progressLabel.right = self.boundsWidth - kHorizontalPadding;
    
    self.progressLabel.top = self.titleLabel.top = kVerticalPadding;
    
    self.currentProgressBar.height = self.fullProgressBar.height = 5;
    self.fullProgressBar.width = maxWidth;
    self.currentProgressBar.width = self.pennyPot ? [self.pennyPot getProgressWidthFrom:maxWidth] : 0;
    
    self.currentProgressBar.left = self.fullProgressBar.left = kHorizontalPadding;
    self.currentProgressBar.bottom = self.fullProgressBar.bottom = self.contentView.bottom - kVerticalPadding;
    
    self.fullProgressBar.layer.cornerRadius = self.currentProgressBar.layer.cornerRadius = self.fullProgressBar.height/2;
}

#pragma mark - Swipe Interaction set up

- (void)addSwipeInteractions
{
    
    __block PPOverviewTableViewCell *blockSelf = self;
    // Configuring the views and colors.
    UIColor *greenColor = [UIColor colorWithRed:85.0 / 255.0 green:213.0 / 255.0 blue:80.0 / 255.0 alpha:1.0];
    
    UIColor *redColor = [UIColor colorWithRed:232.0 / 255.0 green:61.0 / 255.0 blue:14.0 / 255.0 alpha:1.0];
    
    // Setting the default inactive state color to the tableView background color.
    [self setDefaultColor:[UIColor blueColor]];
    
    // Adding gestures per state basis.
    [self setSwipeGestureWithView:self.coinView color:greenColor mode:MCSwipeTableViewCellModeExit state:MCSwipeTableViewCellState1 completionBlock:^(MCSwipeTableViewCell *cell, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode) {
        
        [blockSelf handleSwipeActionsWithMode:mode];
    }];
    
    [self setSwipeGestureWithView:self.trashView color:redColor mode:MCSwipeTableViewCellModeExit state:MCSwipeTableViewCellState3 completionBlock:^(MCSwipeTableViewCell *cell, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode) {
        
        [blockSelf handleSwipeActionsWithMode:mode];
    }];
}

- (void)handleSwipeActionsWithMode:(MCSwipeTableViewCellMode)mode
{
    if ([self.delegate respondsToSelector:@selector(overviewTableViewCell:didSwipeWithCellMode:)]) {
        [self.delegate overviewTableViewCell:self didSwipeWithCellMode:mode];
    }
}

#pragma mark - Getters

- (UIView *)fullProgressBar
{
    if (!_fullProgressBar) {
        _fullProgressBar = [UIView new];
        
        _fullProgressBar.backgroundColor = [UIColor progressBackground];
    }
    return _fullProgressBar;
}

- (UIView *)currentProgressBar
{
    if (!_currentProgressBar) {
        _currentProgressBar = [UIView new];
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

- (UIImageView *)coinView
{
    if (!_coinView) {
        _coinView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"coin"]];
    }
    return _coinView;
}

- (UIImageView *)trashView
{
    if (!_trashView) {
        _trashView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"trash"]];
    }
    return _trashView;
}

#pragma mark - Class

+ (NSString *)reuseIdentifier
{
    return @"PPOverviewTableViewCell";
}

+ (CGFloat)heightForModel:(NSObject *)model
{
    return 65.0f;
}

@end
