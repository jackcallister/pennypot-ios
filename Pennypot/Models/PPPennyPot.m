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
    }
    return self;
}

#pragma mark - Setters

- (void)setCurrentProgress:(NSInteger)currentProgress
{
    if (currentProgress > _savingsGoal) {
        NSAssert(@"", nil);
        return;
    }
    
    _currentProgress = currentProgress;
}

#pragma mark - Getters

- (BOOL)isSavingsGoalReached
{
    if (_currentProgress >= _savingsGoal) {
        return YES;
    }
    return NO;
}

@end
