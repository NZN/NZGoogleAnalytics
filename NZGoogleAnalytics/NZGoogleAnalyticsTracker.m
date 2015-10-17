//
//  NZGoogleAnalyticsTracker.m
//  NZGoogleAnalytics
//
//  Created by Bruno Tortato Furtado on 14/12/13.
//  Copyright (c) 2013 No Zebra Network. All rights reserved.
//

#import "NZGoogleAnalyticsTracker.h"
#import "GAI.h"
#import "GAIDictionaryBuilder.h"
#import "GAIFields.h"

static NSArray* Views = nil;
static NSString* const kResourceName = @"NZGoogleAnalytics-Tracker";



@interface NZGoogleAnalyticsTracker ()

+ (NSString *)viewNameForController:(UIViewController *)controller;
@end



@implementation NZGoogleAnalyticsTracker

#pragma mark -
#pragma mark - NSObject

+ (void)load
{
#ifdef NZDEBUG
    NSLog(@"%s", __PRETTY_FUNCTION__);
#endif
    
    [super load];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:kResourceName ofType:@"plist"];
    
    if (path && [[NSFileManager defaultManager] fileExistsAtPath:path]) {
        Views = [[NSArray alloc] initWithContentsOfFile:path];
    }

    if (Views == nil) {
        NSLog(@"%s \"%@.plist\" not found or not configurated. \
              Check if the file has been added to your project and add 'class_name' keys and 'view_name' values to array.",
              __PRETTY_FUNCTION__, kResourceName);
    }
}

#pragma mark -
#pragma mark - Public methods

+ (void)trackEventWithCategory:(NSString *)categoty action:(NSString *)action label:(NSString *)label
{
    NSNumber *value = [NSNumber numberWithInt:1];
    [self trackEventWithCategory:categoty action:action label:label value:value];
}

+ (void)trackEventWithCategory:(NSString *)categoty action:(NSString *)action label:(NSString *)label value:(NSNumber *)value
{
    [self trackEventWithCategory:categoty action:action label:label value:value nonInteraction:NO];
}

+ (void)trackEventWithCategory:(NSString *)categoty action:(NSString *)action label:(NSString *)label value:(NSNumber *)value nonInteraction:(BOOL)nonInteraction
{
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    tracker.allowIDFACollection = YES;
    
    [tracker set:kGAINonInteraction value:(nonInteraction) ? @"true" : @"false"];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:categoty
                                                          action:action
                                                           label:label
                                                           value:value] build]];
}

+ (void)trackViewWithController:(UIViewController *)controller
{
    [self trackViewWithController:controller withIdentifier:nil];
}

+ (void)trackViewWithController:(UIViewController *)controller withIdentifier:(NSString *)identifier
{
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    tracker.allowIDFACollection = YES;
    
    NSString *viewName = [self viewNameForController:controller];
    
    if (viewName) {
        NSMutableString *string = [[NSMutableString alloc] initWithString:@"/ios/"];
        [string appendString:viewName];
        
        if (identifier) {
            [string appendFormat:@"/%@", identifier];
        }
        
        [tracker set:kGAIScreenName value:string];
        [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    } else {
#ifdef NZDEBUG
        NSLog(@"%s nil tracker name for controller: %@",
              __PRETTY_FUNCTION__, NSStringFromClass([controller class]));
#endif
    }
}

#pragma mark -
#pragma mark - Private methods

+ (NSString *)viewNameForController:(UIViewController *)controller
{
    NSString *controllerName = NSStringFromClass([controller class]);
    NSString *viewName = nil;
    
    if (Views) {
        for (NSDictionary *dictionary in Views) {
            if (dictionary) {
                NSString *className = [dictionary objectForKey:@"class_name"];
                
                if (className && [className isEqualToString:controllerName]) {
                    viewName = [dictionary objectForKey:@"view_name"];
                    break;
                }
            }
        }
    }
    
    return viewName;
}

@end
