//
//  PPPennyPotDetailView.m
//  Pennypot
//
//  Created by Matthew Nydam on 5/12/14.
//  Copyright (c) 2014 PP. All rights reserved.
//

#import "PPPennyPotDetailView.h"
#import "PPPennyPot.h"

#import <ViewUtils/ViewUtils.h>

typedef NS_ENUM(NSInteger, PPDetailViewMode) {
    PPDetailViewModeNew,
    PPDetailViewModeEdit
};

@interface PPPennyPotDetailView ()

@property (nonatomic) PPDetailViewMode mode;

@property (nonatomic, strong) PPPennyPot *pennyPot;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *goalLabel;

@property (nonatomic, strong) UITextField *titleTextField;
@property (nonatomic, strong) UITextField *goalTextField;

@end

@implementation PPPennyPotDetailView

- (id)initWithObject:(PPPennyPot *)object
{
    if (self = [super init]) {
        
        self.mode = PPDetailViewModeNew;
        if (object) {
            self.pennyPot = object;
            self.mode = PPDetailViewModeEdit;
        }
        [self addSubview:self.titleLabel];
        [self addSubview:self.goalLabel];
        
        [self addSubview:self.titleTextField];
        [self addSubview:self.goalTextField];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

#pragma mark - Layout

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.titleTextField.height = self.goalTextField.height = 50.0f;
    
    self.titleTextField.width = self.goalTextField.width = self.boundsWidth - 40.0f;
    self.titleTextField.left = self.goalTextField.left = 20.0f;
    
    self.titleTextField.top = 40.0f;
    self.goalTextField.top = self.titleTextField.bottom + 20.0f;
}

#pragma mark - Data Loading

- (PPPennyPot *)getObjectFromFields
{
    if (self.titleTextField.text && self.goalTextField.text) {
        PPPennyPot *pot = [[PPPennyPot alloc] initWithTitle:self.titleTextField.text andSavingsGoal:[self.goalTextField.text integerValue]];
        return pot;
    }
    return nil;
}

#pragma mark - Getters

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.text = @"Title";
    }
    return _titleLabel;
}

- (UILabel *)goalLabel
{
    if (!_goalLabel) {
        _goalLabel = [UILabel new];
        _goalLabel.text = @"Goal";
    }
    return _goalLabel;
}

- (UITextField *)titleTextField
{
    if (!_titleTextField) {
        _titleTextField = [UITextField new];
        _titleTextField.backgroundColor = [UIColor lightGrayColor];
    }
    return _titleTextField;
}

- (UITextField *)goalTextField
{
    if (!_goalTextField) {
        _goalTextField = [UITextField new];
        _goalTextField.backgroundColor = [UIColor lightGrayColor];
    }
    return _goalTextField;
}

@end
