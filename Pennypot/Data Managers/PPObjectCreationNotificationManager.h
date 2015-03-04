//
//  PPObjectCreationNotificationManager.h
//  Pennypot
//
//  Created by Matthew Nydam on 28/02/15.
//  Copyright (c) 2015 PP. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PPObjectCreationNotificationManager : NSObject

+ (void)registerForStateChangedNotificationWithObserver:(id)observer andStateChangeSelector:(SEL)selector;
+ (void)deregisterForStateChangedNotificationWithObserver:(id)observer;

// If this notification came from the + button on the header view,
// pass true.
+ (void)sendStateChangedNotificationWithUIChangeIntention:(BOOL)shouldChangeUI;

@end
