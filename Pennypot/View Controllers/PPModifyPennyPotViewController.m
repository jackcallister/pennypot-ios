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

@property (nonatomic, strong) UIButton *doneButton;
@property (nonatomic, strong) UIButton *cancelButton;

@property (nonatomic, strong) UIImageView *backgroundImage;
@property (nonatomic, strong) UIScrollView *scrollView;

@end

static const CGFloat kEdgeInsets = 15.0f;

@implementation PPModifyPennyPotViewController

-(id)initWithObject:(PPPennyPot *)object
{
    if (self = [super init]) {
        [self.view addSubview:self.scrollView];
        [self.scrollView insertSubview:self.backgroundImage atIndex:0];
        
        [self.view addSubview:self.doneButton];
        [self.view addSubview:self.cancelButton];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];

    self.scrollView.contentSize = CGSizeMake(self.view.boundsWidth, self.backgroundImage.height);
    
    [self.scrollView setContentOffset:CGPointMake(0, self.scrollView.contentSize.height/2)];
    
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
    
}

#pragma mark - Scroll View Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
}

#pragma mark - Actions

- (IBAction)doneButtonPressed:(id)sender
{
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
    }
    return _cancelButton;
}

@end
