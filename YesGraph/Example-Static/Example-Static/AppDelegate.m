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
        // Give your user a unique UserID here. This should be unique for each user of your app.
        NSString *userId = [YSGUtility randomUserId];
        [[YesGraph shared] configureWithUserId:userId];
        
        //
        // Configuring the source of contacts really helps us working with contacts.
        //
        YSGSource* source = [[YSGSource alloc] init];
        source.name = @"Name";
        source.email = @"Email";
        source.phone = @"+1 123 123 123";
        
        [[YesGraph shared] setContactOwnerMetadata:source];
    }
    
    //
    // Client key should be retrieved from your trusted backend and is cached in the YesGraph SDK.
    // If user logins with another user ID, new client key must be configured.
    
    if (![YesGraph shared].clientKey.length)
    {
        
        // Replace this URL with your server URL to retrieve the client key from your server
        NSString *urlPath = [NSString stringWithFormat:@"https://yesgraph-client-key-test.herokuapp.com/client-key/%@", [YesGraph shared].userId];
        NSURL *url = [NSURL URLWithString: urlPath];
        NSURLSession *session = [NSURLSession sharedSession];
        
        [[session dataTaskWithURL:url
                completionHandler:^(NSData *data,
                                    NSURLResponse *response,
                                    NSError *error) {
                    NSError *jsonError;
                    NSDictionary *jsonResult = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
                    
                    NSString *clientKey = [jsonResult objectForKey:@"message"];
                    
                    [[YesGraph shared] configureWithClientKey:clientKey];
                    
                }] resume];
        
    }
    
    return YES;
}

@end
