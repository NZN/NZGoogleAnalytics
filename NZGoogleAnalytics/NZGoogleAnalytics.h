//
//  NZGoogleAnalytics.h
//  NZGoogleAnalytics
//
//  Created by Bruno Tortato Furtado on 14/12/13.
//  Copyright (c) 2013 No Zebra Network. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GAI.h"

@interface NZGoogleAnalytics : NSObject

- (instancetype) init
__attribute__((unavailable("[-init] is not allowed")));

+ (void)setTrackingId:(NSString *)trackingId;

+ (BOOL)trackUncaughtExceptions;
+ (void)setTrackUncaughtExceptions:(BOOL)trackUncaughtExceptions;

+ (NSTimeInterval)dispatchInterval;
+ (void)setDispatchInterval:(NSTimeInterval)dispatchInterval;

+ (GAILogLevel)logLevel;
+ (void)setLogLevel:(GAILogLevel)logLevel;

@end
