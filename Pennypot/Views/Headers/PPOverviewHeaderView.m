//
//  PPOverviewHeaderView.m
//  Pennypot
//
//  Created by Matthew Nydam on 19/11/14.
//  Copyright (c) 2014 PP. All rights reserved.
//

#import "PPOverviewHeaderView.h"

@interface PPOverviewHeaderView ()

@property (nonatomic, strong) UIImageView *backgroundImageView;

@end

@implementation PPOverviewHeaderView

- (id)initWithImage:(UIImage *)image
{
    self = [super init];
    if (self) {
        self.backgroundImageView = [[UIImageView alloc] initWithImage:image];
        
        [self addSubview:self.backgroundImageView];
    }
    return self;
}

#pragma mark - Class

+ (CGFloat)heightForImage:(UIImage *)image
{
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    return imageView.frame.size.height;
}

@end
