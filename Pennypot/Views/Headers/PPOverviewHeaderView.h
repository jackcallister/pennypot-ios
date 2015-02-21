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

@property (nonatomic, strong) UIButton *addButton;

- (id)initWithImage:(UIImage *)image;
// Class
+ (CGFloat)headerHeight;

@end
