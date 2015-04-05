//
//  PPDataManager.h
//  Pennypot
//
//  Created by Matthew Nydam on 30/11/14.
//  Copyright (c) 2014 PP. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PPPennyPot;

@interface PPDataManager : NSObject

+ (instancetype)sharedManager;

- (NSInteger)numberOfPennyObjects;

- (void)addPennyPotToArray:(PPPennyPot *)pennyPot;

- (void)deletePennyObject:(PPPennyPot *)pennyObject;

- (PPPennyPot *)pennyPotAtPosition:(NSInteger)position;

- (void)updateObjects;

@end
