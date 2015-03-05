//
//  PPOverviewHeaderView.m
//  Pennypot
//
//  Created by Matthew Nydam on 19/11/14.
//  Copyright (c) 2014 PP. All rights reserved.
//

#import "PPOverviewHeaderView.h"

#import "PPAnimatingAddControl.h"

#import <ViewUtils/ViewUtils.h>

@interface PPOverviewHeaderView ()

@property (nonatomic) CGRect backgroundFrameWithUpdates;

@property (nonatomic, strong) UIScrollView *backgroundScrollView;
@property (nonatomic, strong) UIImageView *backgroundImageView;


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
    }
    
    self.addButton.height = self.addButton.width = 50;
    self.addButton.right = self.boundsWidth - kPadding;
    self.addButton.bottom = self.boundsHeight - kPadding;
    
}

- (void)layoutHeaderViewForScrollViewOffset:(CGPoint)offset
{
    CGRect backgroundFrame = self.backgroundScrollView.frame;
    
    if (offset.y > 0)
    {
        backgroundFrame.origin.y = MAX(offset.y *kParallaxDeltaFactor, 0);
        
        self.backgroundScrollView.frame = backgroundFrame;
        
        self.clipsToBounds = YES;
    }
    else
    {
        CGFloat delta = 0.0f;
        CGRect defaultFrame = kDefaultHeaderFrame;
        
        delta = fabs(MIN(0.0f, offset.y));
        defaultFrame.origin.y -= delta;
        defaultFrame.size.height += delta;
        
        self.backgroundScrollView.frame = defaultFrame;
        self.clipsToBounds = NO;
    }
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


#pragma mark - Class

+ (CGFloat)headerHeight
{
    return 200.0f;
}

@end
