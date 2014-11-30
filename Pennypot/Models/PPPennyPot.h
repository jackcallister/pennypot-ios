//
//  PPPennyPot.h
//  Pennypot
//
//  Created by Matthew Nydam on 22/11/14.
//  Copyright (c) 2014 PP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PPPennyPot : NSObject

@property (nonatomic, strong) NSString *title;

@property (nonatomic) CGFloat currentPercent;

@property (nonatomic) NSInteger currentProgress;
@property (nonatomic) NSInteger savingsGoal;

@property (nonatomic, strong) NSString *formattedDisplayValue;

@property (nonatomic) BOOL isSavingsGoalReached;

- (id)initWithTitle:(NSString *)title andSavingsGoal:(NSInteger)savingsGoal;

- (CGFloat)getProgressWidthFrom:(CGFloat)maxWidth;

@end
