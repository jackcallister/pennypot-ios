//
//  PPPennyPot.m
//  Pennypot
//
//  Created by Matthew Nydam on 22/11/14.
//  Copyright (c) 2014 PP. All rights reserved.
//

#import "PPPennyPot.h"
#import "UIColor+PennyColor.h"

@interface PPPennyPot ()

@property (nonatomic, strong) NSDate *timestamp;

//Private Helpers
- (UIColor *)retrieveColorFromPercentage:(CGFloat)percentage;
- (BOOL)number:(CGFloat)comparison isBetween:(CGFloat)bottom and:(CGFloat)top;

@end

@implementation PPPennyPot

- (instancetype)initWithTitle:(NSString *)title andSavingsGoal:(NSInteger)savingsGoal
{
    self = [super init];
    if (self) {
        _title = title;
        _savingsGoal = savingsGoal;
        _currentProgress = 0;
        _currentPercent = 0;
        
        _timestamp = [NSDate date];
    }
    return self;
}

#pragma mark - User defaults

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.title forKey:@"title"];
    [encoder encodeInteger:self.savingsGoal forKey:@"savingsGoal"];
    [encoder encodeInteger:self.currentProgress forKey:@"currentProgress"];
    [encoder encodeFloat:self.currentPercent forKey:@"currentPercent"];
    [encoder encodeObject:self.timestamp forKey:@"timestamp"];
}

- (instancetype)initWithCoder:(NSCoder *)decoder
{
    if((self = [super init])) {
        self.title = [decoder decodeObjectForKey:@"title"];
        self.savingsGoal = [decoder decodeIntegerForKey:@"savingsGoal"];
        self.currentProgress = [decoder decodeIntegerForKey:@"currentProgress"];
        self.currentPercent = [decoder decodeFloatForKey:@"currentPercent"];
        self.timestamp = [decoder decodeObjectForKey:@"timestamp"];
    }
    return self;
}

#pragma mark - Public

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
    if (self.savingsGoal > 0 && self.currentProgress >= 0) {
        return [NSString stringWithFormat:@"$%@ of $%@", @(self.currentProgress), @(self.savingsGoal)];
    }
    return @"";
}

- (UIColor *)progressColor
{
    return [self retrieveColorFromPercentage:self.currentPercent];
}

#pragma mark - Equality

- (BOOL)isEqual:(id)object {
    
    if ([object isKindOfClass:[PPPennyPot class]]) {
        
         PPPennyPot *comparisonObject = (PPPennyPot *)object;
        
        if (self.title == comparisonObject.title && self.savingsGoal == comparisonObject.savingsGoal && self.timestamp == comparisonObject.timestamp) {
            return YES;
        }
    }
    return NO;
}

#pragma mark - Helpers

- (UIColor *)retrieveColorFromPercentage:(CGFloat)percentage
{
    if ([self number:percentage isBetween:0 and:10]) {
        return [UIColor progressZero];
    } else if ([self number:percentage isBetween:10 and:20]) {
        return [UIColor progressTen];
    } else if ([self number:percentage isBetween:20 and:30]) {
        return [UIColor progressTwenty];
    } else if ([self number:percentage isBetween:30 and:40]) {
        return [UIColor progressThirty];
    } else if ([self number:percentage isBetween:40 and:50]) {
        return [UIColor progressForty];
    } else if ([self number:percentage isBetween:50 and:60]) {
        return [UIColor progressFifty];
    } else if ([self number:percentage isBetween:60 and:70]) {
        return [UIColor progressSixty];
    } else if ([self number:percentage isBetween:70 and:80]) {
        return [UIColor progressSeventy];
    } else if ([self number:percentage isBetween:80 and:90]) {
        return [UIColor progressEighty];
    } else if ([self number:percentage isBetween:90 and:101]) {
        return [UIColor progressNinety];
    }
    
    return [UIColor clearColor];
}

- (BOOL)number:(CGFloat)comparison isBetween:(CGFloat)bottom and:(CGFloat)top
{
    if (comparison >= bottom && comparison < top) {
        return YES;
    }
    return NO;
}

@end
