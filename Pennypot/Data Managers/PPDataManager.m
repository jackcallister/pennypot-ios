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

static NSString * const kUserDefaultKey = @"PennyObjects";

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
        
        self.pennyData = [self retrieveUserdefaults];
        
        PPPennyPot *pennyOne = [[PPPennyPot alloc] initWithTitle:@"New York" andSavingsGoal:3000];
        PPPennyPot *pennyTwo = [[PPPennyPot alloc] initWithTitle:@"Skiing" andSavingsGoal:500];
        
        PPPennyPot *pennyThree = [[PPPennyPot alloc] initWithTitle:@"Taupo" andSavingsGoal:200];
        PPPennyPot *pennyFour = [[PPPennyPot alloc] initWithTitle:@"China Trip" andSavingsGoal:500];
        PPPennyPot *pennyFive = [[PPPennyPot alloc] initWithTitle:@"Turntable" andSavingsGoal:700];
        PPPennyPot *pennySix = [[PPPennyPot alloc] initWithTitle:@"Benji Record" andSavingsGoal:30];
        PPPennyPot *pennySeven = [[PPPennyPot alloc] initWithTitle:@"PS4" andSavingsGoal:550];
        PPPennyPot *pennyEight = [[PPPennyPot alloc] initWithTitle:@"iPhone 6+" andSavingsGoal:1200];
        
        pennyOne.currentProgress = 2000;
        pennyTwo.currentProgress = 150;
        pennyThree.currentProgress = 200;
        pennyFour.currentProgress = 450;
        pennyFive.currentProgress = 1;
        pennySix.currentProgress = 20;
        pennySeven.currentProgress = 12;
        pennyEight.currentProgress = 0;
        
        [self addPennyPotToArray:pennyOne];
        [self addPennyPotToArray:pennyTwo];
        [self addPennyPotToArray:pennyThree];
        [self addPennyPotToArray:pennyFour];
        [self addPennyPotToArray:pennyFive];
        [self addPennyPotToArray:pennySix];
        [self addPennyPotToArray:pennySeven];
        [self addPennyPotToArray:pennyEight];

        
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
    [self saveToUserDefaults];
}

- (void)deletePennyObject:(PPPennyPot *)pennyObject
{
    NSMutableArray *deleteArray = [NSMutableArray arrayWithArray:self.pennyData];
    if ([deleteArray containsObject:pennyObject]) {
        [deleteArray removeObject:pennyObject];
        self.pennyData = [NSArray arrayWithArray:deleteArray];
    }
    [self saveToUserDefaults];
}

- (PPPennyPot *)pennyPotAtPosition:(NSInteger)position
{
    return self.pennyData[position];
}

#pragma mark - User Defaults

- (void)saveToUserDefaults
{
    NSData *rawObjectData = [NSKeyedArchiver archivedDataWithRootObject:self.pennyData];
    [[NSUserDefaults standardUserDefaults] setObject:rawObjectData forKey:kUserDefaultKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSArray *)retrieveUserdefaults
{
    NSArray *rawObjectArray = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultKey]];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    return rawObjectArray;
}

@end
