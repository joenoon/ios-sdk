//
//  AppDelegate.m
//  Example-Static
//
//  Created by Gasper Rebernak on 15/09/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

#import "AppDelegate.h"

#import <YesGraphSDK/YesGraphSDK.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //
    // Configures YesGraph with a specific User ID and Source, so we know where are contacts from.
    //
    if (![YesGraph shared].userId.length)
    {
        [[YesGraph shared] configureWithUserId:[YSGUtility randomUserId]];
        
        //
        // Configuring the source of contacts really helps us working with contacts.
        //
        /*YSGSource* source = [[YSGSource alloc] init];
         source.name = @"Name";
         source.email = @"Email";
         source.phone = @"+1 123 123 123";
         
         [[YesGraph shared] setContactOwnerMetadata:source];*/
    }
    
    //
    // Client key should be retrieved from your trusted backend and is cached in the YesGraph SDK.
    // If user logins with another user ID, new client key must be configured.
    //
    [[YesGraph shared] configureWithClientKey:@""];
    
    return YES;
}

@end
