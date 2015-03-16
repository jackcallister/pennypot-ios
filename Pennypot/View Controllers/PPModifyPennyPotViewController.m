//
//  PPAddPennyPotViewController.m
//  Pennypot
//
//  Created by Matthew Nydam on 30/11/14.
//  Copyright (c) 2014 PP. All rights reserved.
//

#import "PPModifyPennyPotViewController.h"
#import "PPPennyPotDetailView.h"
#import "PPPennyPot.h"
#import <ViewUtils/ViewUtils.h>

@interface PPModifyPennyPotViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) PPPennyPot *pennyObject;

@property (nonatomic, strong) UILabel *currencyLabel;
@property (nonatomic, strong) UILabel *amountLabel;

@property (nonatomic, strong) UIButton *doneButton;
@property (nonatomic, strong) UIButton *cancelButton;

@property (nonatomic, strong) UIImageView *backgroundImage;
@property (nonatomic, strong) UIScrollView *scrollView;

- (CGFloat)calculateScrollViewStartPosition;
- (void)calculateAmountLabelWithScrollView:(UIScrollView *)scrollView;
@end

static const CGFloat kEdgeInsets = 25.0f;

@implementation PPModifyPennyPotViewController

- (instancetype)initWithObject:(PPPennyPot *)object
{
    if (self = [super init]) {
        
        self.pennyObject = object;

        [self.view addSubview:self.scrollView];
        [self.scrollView insertSubview:self.backgroundImage atIndex:0];
        
        [self.view addSubview:self.doneButton];
        [self.view addSubview:self.cancelButton];
        
        [self.view addSubview:self.currencyLabel];
        [self.view addSubview:self.amountLabel];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];

    self.scrollView.contentSize = CGSizeMake(self.view.boundsWidth, self.backgroundImage.height);
    
    [self calculateAmountLabelWithScrollView:self.scrollView];

}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    self.backgroundImage.width = self.view.boundsWidth;
    self.scrollView.frame = self.view.bounds;
    
    self.doneButton.height = self.cancelButton.height = 60.0f;
    self.doneButton.width = self.cancelButton.width = 80.0f;
    
    self.doneButton.bottom = self.cancelButton.bottom = self.view.boundsHeight - 10;
    
    self.cancelButton.left = kEdgeInsets;
    self.doneButton.right = self.view.boundsWidth - kEdgeInsets;

    self.amountLabel.bottom = self.currencyLabel.bottom = self.view.center.y;
    self.currencyLabel.left = kEdgeInsets;
    self.amountLabel.left = self.currencyLabel.right + 5;
    self.amountLabel.width = self.view.boundsWidth - (kEdgeInsets) - self.amountLabel.left;
    
    [self.scrollView setContentOffset:CGPointMake(0, (self.scrollView.contentSize.height - self.view.boundsHeight) - [self calculateScrollViewStartPosition])];
    
}



#pragma mark - Scroll View Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self calculateAmountLabelWithScrollView:scrollView];
}

#pragma mark - Value calculations

- (void)calculateAmountLabelWithScrollView:(UIScrollView *)scrollView
{
    CGFloat maxHeight = scrollView.contentSize.height - self.view.boundsHeight;
    CGFloat calculatedOffsetDiff = (scrollView.contentOffset.y + scrollView.frame.size.height) - self.view.boundsHeight;
    CGFloat value = self.pennyObject.currentProgress;
    
    
    if (self.pennyObject) {
        
        if (scrollView.contentOffset.y <= 0) {
            value = self.pennyObject.savingsGoal;
        } else if (scrollView.contentOffset.y >= maxHeight) {
            value = 0.0f;
        } else {
            CGFloat differenceRatio = (maxHeight / self.pennyObject.savingsGoal);
            value = roundf((maxHeight - calculatedOffsetDiff)/ differenceRatio);
        }
    }
    
    self.amountLabel.text = [NSString stringWithFormat:@"%@", @(value)];
}

- (CGFloat)calculateScrollViewStartPosition
{
    CGFloat goalPercentage = self.pennyObject.currentPercent;
    CGFloat maxHeight = self.scrollView.contentSize.height - self.view.boundsHeight;
    
    return maxHeight * (goalPercentage/100.0f);
}


#pragma mark - Actions

- (IBAction)doneButtonPressed:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(modifyViewControllerDidReturnPennyPot:)]) {
        self.pennyObject.currentProgress = [self.amountLabel.text floatValue];
        [self.delegate modifyViewControllerDidReturnPennyPot:self.pennyObject];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)cancelButtonPressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Getters

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [UIScrollView new];
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.delegate = self;
        [_scrollView setShowsVerticalScrollIndicator:NO];
    }
    return _scrollView;
}

- (UIImageView *)backgroundImage
{
    if (!_backgroundImage) {
        _backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"scrollGradient"]];
        _backgroundImage.contentMode = UIViewContentModeScaleAspectFill;

    }
    return _backgroundImage;
}

- (UIButton *)doneButton
{
    if (!_doneButton) {
        _doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_doneButton setTitle:@"Done" forState:UIControlStateNormal];
        [_doneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_doneButton addTarget:self action:@selector(doneButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        _doneButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;

    }
    return _doneButton;
}

- (UIButton *)cancelButton
{
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(cancelButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        _cancelButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;

    }
    return _cancelButton;
}

- (UILabel *)currencyLabel
{
    if (!_currencyLabel) {
        _currencyLabel = [UILabel new];
        _currencyLabel.text = @"$";
        _currencyLabel.textColor = [UIColor whiteColor];
        _currencyLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:50];
        [_currencyLabel sizeToFit];
    }
    return _currencyLabel;
}

- (UILabel *)amountLabel
{
    if (!_amountLabel) {
        _amountLabel = [UILabel new];
        _amountLabel.text = @"0";
        _amountLabel.textColor = [UIColor whiteColor];
        _amountLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:50];
        [_amountLabel sizeToFit];
    }
    return _amountLabel;
}

@end
