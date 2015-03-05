//
//  PPOverviewHeaderView.m
//  Pennypot
//
//  Created by Matthew Nydam on 19/11/14.
//  Copyright (c) 2014 PP. All rights reserved.
//

#import "PPOverviewHeaderView.h"

#import "PPAnimatingAddControl.h"
#import "UIImage+ImageEffects.h"

#import <ViewUtils/ViewUtils.h>

@interface PPOverviewHeaderView ()

@property (nonatomic) CGRect backgroundFrameWithUpdates;

@property (nonatomic, strong) UIScrollView *backgroundScrollView;

@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic) IBOutlet UIImageView *blurredImageView;



@end

#define kDefaultHeaderFrame CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)

static CGFloat kParallaxDeltaFactor = 0.6f;
static const CGFloat kPadding = 20.0f;

@implementation PPOverviewHeaderView

- (id)initWithImage:(UIImage *)image
{
    self = [super init];
    if (self) {
        
        self.backgroundImageView.image = image;
        
        [self.backgroundScrollView addSubview:self.backgroundImageView];
        [self.backgroundImageView addSubview:self.blurredImageView];
        
        [self addSubview:self.backgroundScrollView];
        [self addSubview:self.addButton];
        
    }
    return self;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // Layout once. The rest of the time or scroll view
    // will take care of it.
    if (CGRectIsEmpty(self.backgroundScrollView.frame)) {
        self.backgroundScrollView.frame = self.bounds;
        self.backgroundImageView.frame = self.bounds;
        self.blurredImageView.frame = self.backgroundImageView.frame;
        
        [self refreshBlurViewForNewImage];
    }
    
    self.addButton.height = self.addButton.width = 50;
    self.addButton.right = self.boundsWidth - kPadding;
    self.addButton.bottom = self.boundsHeight - kPadding;
    
}

- (void)layoutHeaderViewForScrollViewOffset:(CGPoint)offset
{
    CGRect backgroundFrame = self.backgroundScrollView.frame;
    
    if (offset.y > 0) {
        backgroundFrame.origin.y = MAX(offset.y *kParallaxDeltaFactor, 0);
        
        
        self.backgroundScrollView.frame = backgroundFrame;
        
        self.blurredImageView.alpha = (1 / kDefaultHeaderFrame.size.height * offset.y * 2);
        
        self.clipsToBounds = YES;
    
    } else {
        
        CGFloat delta = 0.0f;
        CGRect defaultFrame = kDefaultHeaderFrame;
        
        delta = fabs(MIN(0.0f, offset.y));
        defaultFrame.origin.y -= delta;
        defaultFrame.size.height += delta;
        
        self.blurredImageView.alpha = (1 / kDefaultHeaderFrame.size.height * offset.y * 2) * -1;

        self.backgroundScrollView.frame = defaultFrame;
        self.clipsToBounds = NO;
        
    }
}

#pragma mark - Image Blur

- (UIImage *)screenShotOfView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(kDefaultHeaderFrame.size, YES, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.layer renderInContext:context];
    UIImage *capturedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return capturedImage;
}

- (void)refreshBlurViewForNewImage
{
    UIImage *screenShot = [self screenShotOfView:self];
    screenShot = [screenShot applyBlurWithRadius:5 tintColor:[UIColor colorWithWhite:0.6 alpha:0.2] saturationDeltaFactor:1.0 maskImage:nil];
    self.blurredImageView.image = screenShot;
}


#pragma mark - Getters

- (PPAnimatingAddControl *)addButton
{
    if(!_addButton) {
        _addButton = [PPAnimatingAddControl new];
    }
    return _addButton;
}

- (UIScrollView *)backgroundScrollView
{
    if (!_backgroundScrollView) {
        _backgroundScrollView = [UIScrollView new];
    }
    return _backgroundScrollView;
}

- (UIImageView *)backgroundImageView
{
    if (!_backgroundImageView) {
        _backgroundImageView = [UIImageView new];
        _backgroundImageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;

    }
    return _backgroundImageView;
}

- (UIImageView *)blurredImageView
{
    if (!_blurredImageView) {
        _blurredImageView = [UIImageView new];
        _blurredImageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _blurredImageView.contentMode = UIViewContentModeScaleAspectFill;
        _blurredImageView.alpha = 0.0f;
    }
    return _blurredImageView;
}

#pragma mark - Class

+ (CGFloat)headerHeight
{
    return 200.0f;
}

@end
