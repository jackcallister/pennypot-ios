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

+ (instancetype)sharedManager
{
    static PPDataManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (instancetype)init
{
    if (self = [super init]) {
        self.pennyData = [self retrieveUserdefaults];
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
    
    [addArray insertObject:pennyPot atIndex:0];
    self.pennyData = addArray;
    
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

- (void)updateObjects
{
    [self saveToUserDefaults];
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
    
    if (rawObjectArray) {
        return rawObjectArray;
    } else {
        return [NSArray new];
    }
}

@end
