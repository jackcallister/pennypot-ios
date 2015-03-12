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

@property (nonatomic, strong) UIImageView *backgroundImage;
@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation PPModifyPennyPotViewController

-(id)initWithObject:(PPPennyPot *)object
{
    if (self = [super init]) {
//        [self.view addSubview:self.backgroundImage];
        [self.view addSubview:self.scrollView];
        [self.scrollView insertSubview:self.backgroundImage atIndex:0];
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
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
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

@end
