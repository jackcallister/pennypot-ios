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

@property (nonatomic, strong) UIView *seperatorView;

@end

static const CGFloat kVerticalPadding = 10.0f;
static const CGFloat kHorizontalPadding = 20.0f;

@implementation PPOverviewTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.fullProgressBar];
        [self.contentView addSubview:self.currentProgressBar];
        
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.progressLabel];
        
        [self.contentView addSubview:self.seperatorView];
        
    }
    return self;
}

- (void)configureWithModel:(PPPennyPot *)model
{
    self.pennyPot = model;
    self.titleLabel.text = self.pennyPot.title;
    self.progressLabel.text = self.pennyPot.formattedDisplayValue;
    
    self.currentProgressBar.backgroundColor = self.pennyPot.progressColor;
    
    [self.titleLabel sizeToFit];
    [self.progressLabel sizeToFit];
    
    self.currentProgressBar.hidden = self.pennyPot.currentProgress == 0 ? YES : NO;
    
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
    
    self.seperatorView.width = self.contentView.boundsWidth;
    self.seperatorView.height = 1.0f;
    self.seperatorView.bottom = self.contentView.bottom;
}

#pragma mark - Swipe Interaction set up

- (void)addSwipeInteractions
{
    
    __block PPOverviewTableViewCell *blockSelf = self;
    
    [self setDefaultColor:[UIColor backroundGrey]];
    
    // Adding gestures per state basis.
    [self setSwipeGestureWithView:self.coinView color:[UIColor increaseColor] mode:MCSwipeTableViewCellModeExit state:MCSwipeTableViewCellState1 completionBlock:^(MCSwipeTableViewCell *cell, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode) {
        
        [blockSelf handleSwipeActionsWithMode:PPOverviewCellSwipeTypeEdit];
    }];
    
    [self setSwipeGestureWithView:self.trashView color:[UIColor deleteColor] mode:MCSwipeTableViewCellModeExit state:MCSwipeTableViewCellState3 completionBlock:^(MCSwipeTableViewCell *cell, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode) {
        
        [blockSelf handleSwipeActionsWithMode:PPOverviewCellSwipeTypeDelete];
    }];
}

- (void)handleSwipeActionsWithMode:(PPOverviewCellSwipeMode)mode
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

- (UIView *)seperatorView
{
    if (!_seperatorView) {
        _seperatorView = [UIView new];
        _seperatorView.backgroundColor = [UIColor progressBackground];
    }
    return _seperatorView;
}

#pragma mark - Class

+ (NSString *)reuseIdentifier
{
    return @"PPOverviewTableViewCell";
}

+ (CGFloat)heightForModel:(NSObject *)model
{
    return 66.0f;
}

@end
