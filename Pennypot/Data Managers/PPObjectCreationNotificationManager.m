//
//  PPObjectCreationNotificationManager.m
//  Pennypot
//
//  Created by Matthew Nydam on 28/02/15.
//  Copyright (c) 2015 PP. All rights reserved.
//

#import "PPObjectCreationNotificationManager.h"

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

+ (void)sendStateChangedNotificationWithUIChangeIntention:(BOOL)shouldChangeUI
{
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:stateChangedNotification object:[NSNumber numberWithBool:shouldChangeUI]]];
}

@end
