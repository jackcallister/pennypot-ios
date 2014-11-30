//
//  PPPennyPot.m
//  Pennypot
//
//  Created by Matthew Nydam on 22/11/14.
//  Copyright (c) 2014 PP. All rights reserved.
//

#import "PPPennyPot.h"

@implementation PPPennyPot

- (id)initWithTitle:(NSString *)title andSavingsGoal:(NSInteger)savingsGoal
{
    self = [super init];
    if (self) {
        _title = title;
        _savingsGoal = savingsGoal;
        _currentProgress = 0;
        _currentPercent = 0;
    }
    return self;
}



//func formattedDisplayValue() -> String {
//    
//    return "$" + String(progress) + " of $" + String(goal);
//}

- (CGFloat)getProgressWidthFrom:(CGFloat)maxWidth
{
    
    if (self.currentPercent <= 0 || maxWidth <= 0) {
        return 0;
    }
    
    CGFloat percentageFraction = maxWidth * (self.currentPercent/100.0);
    
    return percentageFraction;
}

#pragma mark - Setters

- (void)setCurrentProgress:(NSInteger)currentProgress
{
    if (currentProgress > _savingsGoal) {
        NSAssert(@"Current Progress cannot be greater than the goal!", nil);
        return;
    }
    
    _currentProgress = currentProgress;
}

#pragma mark - Getters

- (CGFloat)currentPercent
{
    if ((self.savingsGoal < 0) || (self.currentProgress <= 0)) {
        return 0;
    } else if (self.currentProgress >= self.savingsGoal) {
        return 100;
    }
    
    CGFloat currentPercent = ((CGFloat)self.currentProgress / (CGFloat)self.savingsGoal) * 100.0f;
    
    return currentPercent;
}

- (NSString *)formattedDisplayValue
{
    if (self.savingsGoal && self.currentProgress) {
        return [NSString stringWithFormat:@"$%@ of $%@", @(self.currentProgress), @(self.savingsGoal)];
    }
    return @"";
}

- (BOOL)isSavingsGoalReached
{
    if (_currentProgress >= _savingsGoal) {
        return YES;
    }
    return NO;
}

@end
