//
//  PPPennyPot.h
//  Pennypot
//
//  Created by Matthew Nydam on 22/11/14.
//  Copyright (c) 2014 PP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PPPennyPot : NSObject

// User set
@property (nonatomic, strong) NSString *title;
@property (nonatomic) NSInteger currentProgress;
@property (nonatomic) NSInteger savingsGoal;

// Calculated
@property (nonatomic) CGFloat currentPercent;
@property (nonatomic, strong) NSString *formattedDisplayValue;
@property (nonatomic, strong) UIColor *progressColor;

- (id)initWithTitle:(NSString *)title andSavingsGoal:(NSInteger)savingsGoal;

- (CGFloat)getProgressWidthFrom:(CGFloat)maxWidth;

@end
