//
//  AppDelegate.m
//  Example
//
//  Created by Dal Rupnik on 18/08/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

#import "AppDelegate.h"

@import YesGraphSDK;

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
        [[YesGraph shared] configureWithUserId:@"kendall"];
        
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
    [[YesGraph shared] configureWithClientKey:@"WzEsMCwicGFyaWJ1cyIsImtlbmRhbGwiXQ.CXmmBA.lUWMZDo_QkXr6kABc2pD0mZ95Z8"];
    
    return YES;
}

@end
