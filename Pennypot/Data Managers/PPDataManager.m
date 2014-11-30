//
//  PPDataManager.m
//  Pennypot
//
//  Created by Matthew Nydam on 30/11/14.
//  Copyright (c) 2014 PP. All rights reserved.
//

#import "PPDataManager.h"
#import "PPPennyPot.h"

@interface PPDataManager ()

@property (nonatomic, strong) NSArray *pennyData;

@end

@implementation PPDataManager

+ (id)sharedManager
{
    static PPDataManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (id)init
{
    if (self = [super init]) {
        
        self.pennyData = [NSArray new];
        
        PPPennyPot *pennyOne = [[PPPennyPot alloc] initWithTitle:@"New York" andSavingsGoal:3000];
        PPPennyPot *pennyTwo = [[PPPennyPot alloc] initWithTitle:@"Skiing" andSavingsGoal:500];
        
        pennyOne.currentProgress = 1000;
        pennyTwo.currentProgress = 250;
        
        [self addPennyPotToArray:pennyOne];
        [self addPennyPotToArray:pennyTwo];
        
    }
    return self;
}

#pragma mark - Manipulation

- (NSInteger)numberOfPennyObjects
{
    return [self.pennyData count];
}

- (void)addPennyPotToArray:(PPPennyPot *)pennyPot
{
    NSMutableArray *addArray = [NSMutableArray arrayWithArray:self.pennyData];
    
    [addArray addObject:pennyPot];
    
    self.pennyData = [NSArray arrayWithArray:addArray];
}

- (PPPennyPot *)pennyPotAtPosition:(NSInteger)position
{
    return self.pennyData[position];
}



@end
