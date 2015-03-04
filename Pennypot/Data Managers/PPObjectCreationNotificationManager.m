//
//  PPObjectCreationNotificationManager.m
//  Pennypot
//
//  Created by Matthew Nydam on 28/02/15.
//  Copyright (c) 2015 PP. All rights reserved.
//

#import "PPObjectCreationNotificationManager.h"
#import "PPAnimatingAddControl.h"

static NSString * const originatedObjectKey = @"originatedObjectKey";
static NSString * const uiStateChangeKey = @"uiStateChangeKey";

static NSString * const stateChangedNotification = @"stateChangedNotification";

@implementation PPObjectCreationNotificationManager

#pragma mark - Registration

+ (void)registerForStateChangedNotificationWithObserver:(id)observer andStateChangeSelector:(SEL)selector
{
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:selector name:stateChangedNotification object:nil];
}

+ (void)deregisterForStateChangedNotificationWithObserver:(id)observer
{
    [[NSNotificationCenter defaultCenter] removeObserver:observer];
}

#pragma mark - Sending

+ (void)sendStateChangedNotificationWithObject:(id)object andUIChangeIntention:(BOOL)shouldChangeUI
{
    
    NSDictionary *informationDictionary = @{uiStateChangeKey:[NSNumber numberWithBool:shouldChangeUI], originatedObjectKey : [NSNumber numberWithBool:[object isKindOfClass:[PPAnimatingAddControl class]]]};
    
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:stateChangedNotification object:informationDictionary]];
}

#pragma mark - Parsing

+ (BOOL)didOriginateFromAddControl:(NSDictionary *)dictionary
{
    if (dictionary[uiStateChangeKey]) {
        return [dictionary[uiStateChangeKey] boolValue];
    }
    return NO;
}

+ (BOOL)doesContainUIChangeIntention:(NSDictionary *)dictionary
{
    if (dictionary[originatedObjectKey]) {
        return [dictionary[originatedObjectKey] boolValue];
    }
    return NO;
}

@end
