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
#import "PPPennyPot.h"

@interface PPCreateObjectView () <UITextFieldDelegate>

@property (nonatomic) BOOL nameTextFieldIsEmpty;
@property (nonatomic) BOOL valueTextFieldIsEmpty;

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *valueLabel;

@property (nonatomic, strong) UITextField *nameTextField;
@property (nonatomic, strong) UITextField *valueTextField;

@property (nonatomic, strong) UIView *keyline;
@property (nonatomic, strong) UIView *bottomKeyline;

- (CGFloat)valueFromTextField;

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
        [self addSubview:self.bottomKeyline];
        
        [self.nameLabel sizeToFit];
        [self.valueLabel sizeToFit];
        
        self.backgroundColor = [UIColor whiteColor];
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.keyline.height = self.bottomKeyline.height = 1;
    self.keyline.width = self.bottomKeyline.width = self.boundsWidth - (kHorizontalPadding * 2);
    self.keyline.left = self.bottomKeyline.left = kHorizontalPadding;
    
    self.keyline.top = (self.boundsHeight/2) - 0.5f;
    
    self.nameLabel.height = self.nameTextField.height = self.valueLabel.height = self.valueTextField.height = (self.boundsHeight/2) - self.keyline.height;
    
    self.nameLabel.top = self.nameTextField.top = 0;
    self.valueLabel.bottom = self.valueTextField.bottom = self.valueTextField.bottom = self.boundsHeight;
    
    self.nameLabel.left = self.valueLabel.left = kHorizontalPadding;
    
    self.nameTextField.left = self.valueTextField.left = self.valueLabel.right + kTextPadding;
    
    self.valueTextField.width = self.nameTextField.width = self.boundsWidth - (self.valueLabel.right - (kTextPadding * 2));
    
    self.bottomKeyline.top = self.valueLabel.bottom;
    
}

#pragma mark - Text Field Delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == self.valueTextField) {
        if (textField.text.length == 0) {
            textField.text = [NSString stringWithFormat:@"$%@", textField.text];
        }
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if (textField == self.valueTextField && textField.text.length == 1 && [string isEqualToString:@""]) {
        return NO;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.nameTextField) {
        [self.valueTextField becomeFirstResponder];
    } else {
        return NO;
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == self.valueTextField) {
        if (textField.text.length == 1) {
            textField.text = @"";
        }
    }
}

#pragma mark - User feedback

- (void)animateForEmptyTextFields
{
    if (self.nameTextFieldIsEmpty) {
        [self shake:self.nameLabel];
    }
    
    if (self.valueTextFieldIsEmpty) {
        [self shake:self.valueLabel];
    }
}

- (void)shake:(UIView *)view
{
    CABasicAnimation *animation =
    [CABasicAnimation animationWithKeyPath:@"position"];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithControlPoints:.17:.67:.83:.67]];

    [animation setDuration:0.08];
    [animation setRepeatCount:2];
    [animation setAutoreverses:YES];
    
    [animation setFromValue:[NSValue valueWithCGPoint:
                             (CGPoint){[view center].x - 5.0f, [view center].y}]];
    
    [animation setToValue:[NSValue valueWithCGPoint:
                           (CGPoint){[view center].x + 5.0f, [view center].y}]];
    
    [[view layer] addAnimation:animation forKey:@"position"];
}

- (IBAction)confirmButtonPressed:(id)sender
{
}

#pragma mark - External

- (BOOL)shouldDismiss
{
    if (!self.nameTextFieldIsEmpty && !self.valueTextFieldIsEmpty) {
        return YES;
    }
    return NO;
}

- (PPPennyPot *)retrieveObjectFromFormAnimateError
{
    if (self.shouldDismiss) {
        PPPennyPot *object = [[PPPennyPot alloc] initWithTitle:self.nameTextField.text andSavingsGoal: [self valueFromTextField]];
        
        return object;
    } else {
        [self animateForEmptyTextFields];
        return nil;
    }
}

- (void)resignRespondersAndClearData
{
    [self.nameTextField resignFirstResponder];
    [self.valueTextField resignFirstResponder];

    self.nameTextField.text = @"";
    self.valueTextField.text = @"";
}

- (void)initialResponder
{
    [self.nameTextField becomeFirstResponder];
}

#pragma mark - Util

- (CGFloat)valueFromTextField
{
    return [[self.valueTextField.text substringFromIndex:1] floatValue];
}

#pragma mark - Getters

- (BOOL)nameTextFieldIsEmpty
{
    return self.nameTextField.text.length == 0 ? YES : NO;
}

- (BOOL)valueTextFieldIsEmpty
{
    return self.valueTextField.text.length <= 1 ? YES : NO;
}

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
        _nameTextField.delegate = self;
        _nameTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    }
    return _nameTextField;
}

- (UITextField *)valueTextField
{
    if (!_valueTextField) {
        _valueTextField = [[UITextField alloc] initWithFrame:CGRectZero];
        [_valueTextField setKeyboardType:UIKeyboardTypeDecimalPad];
        _valueTextField.placeholder = @"$";
        _valueTextField.delegate = self;
        _valueTextField.autocorrectionType = UITextAutocorrectionTypeNo;
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

- (UIView *)bottomKeyline
{
    if (!_bottomKeyline) {
        _bottomKeyline = [UIView new];
        _bottomKeyline.backgroundColor = [UIColor backroundGrey];
    }
    return _bottomKeyline;
}

#pragma mark - Class

+ (CGFloat)heightForView
{
    return 107.0f;
}

@end
