//
//  PPCreateObjectView.m
//  Pennypot
//
//  Created by Matthew Nydam on 21/02/15.
//  Copyright (c) 2015 PP. All rights reserved.
//

#import "PPCreateObjectView.h"
#import <ViewUtils/ViewUtils.h>
#import "UIColor+PennyColor.h"

@interface PPCreateObjectView ()

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *valueLabel;

@property (nonatomic, strong) UITextField *nameTextField;
@property (nonatomic, strong) UITextField *valueTextField;

@property (nonatomic, strong) UIView *keyline;

@end

static const CGFloat kHorizontalPadding = 15.0f;
static const CGFloat kTextPadding = 5.0f;


@implementation PPCreateObjectView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self addSubview:self.nameLabel];
        [self addSubview:self.valueLabel];
        [self addSubview:self.keyline];
        [self addSubview:self.nameTextField];
        [self addSubview:self.valueTextField];

        [self.nameLabel sizeToFit];
        [self.valueLabel sizeToFit];
        
        self.backgroundColor = [UIColor whiteColor];
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.keyline.height = 1;
    self.keyline.width = self.boundsWidth - (kHorizontalPadding * 2);
    self.keyline.top = (self.boundsHeight/2) - 0.5f;
    self.keyline.left = kHorizontalPadding;
    
    self.nameLabel.height = self.nameTextField.height = self.valueLabel.height = self.valueTextField.height = (self.boundsHeight/2) - self.keyline.height;
    
    self.nameLabel.top = self.nameTextField.top = 0;
    self.valueLabel.bottom = self.valueTextField.bottom = self.valueTextField.bottom = self.boundsHeight;
    
    self.nameLabel.left = self.valueLabel.left = kHorizontalPadding;
    
    self.nameTextField.left = self.valueTextField.left = self.valueLabel.right + kTextPadding;
    
    self.valueTextField.width = self.nameTextField.width = self.boundsWidth - (self.valueLabel.right - (kTextPadding * 2));
}

#pragma mark - Getters

- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _nameLabel.text = @"I want:";
    }
    return _nameLabel;
}

- (UILabel *)valueLabel
{
    if (!_valueLabel) {
        _valueLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _valueLabel.text = @"It costs:";
    }
    return _valueLabel;
}

- (UITextField *)nameTextField
{
    if (!_nameTextField) {
        _nameTextField = [[UITextField alloc] initWithFrame:CGRectZero];
    }
    return _nameTextField;
}

- (UITextField *)valueTextField
{
    if (!_valueTextField) {
        _valueTextField = [[UITextField alloc] initWithFrame:CGRectZero];
    }
    return _valueTextField;
}

- (UIView *)keyline
{
    if (!_keyline) {
        _keyline = [UIView new];
        _keyline.backgroundColor = [UIColor backroundGrey];
    }
    return _keyline;
}

#pragma mark - Class

+ (CGFloat)heightForView
{
    return 107.0f;
}

@end
