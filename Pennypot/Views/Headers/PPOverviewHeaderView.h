//
//  PPOverviewHeaderView.h
//  Pennypot
//
//  Created by Matthew Nydam on 19/11/14.
//  Copyright (c) 2014 PP. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PPOverviewHeaderView;

@interface PPOverviewHeaderView : UIView

- (instancetype)initWithImage:(UIImage *)image;
- (void)layoutHeaderViewForScrollViewOffset:(CGPoint)offset;

// Class
+ (CGFloat)headerHeight;

@end
