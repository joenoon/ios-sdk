//
//  AppDelegate.m
//  Example
//
//  Created by Dal Rupnik on 18/08/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

NSString *const ParseApplicationID = @"BU2njCAM4ZGNHuh2meG9Ca3zkBjqlbUd1WSwHmGG";
NSString *const ParseClientKey = @"o7bc0AL0X2gmE5eh1doecNSJPKjS6VtpVx1kaEzG";

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [Parse setApplicationId:ParseApplicationID clientKey:ParseClientKey];
    
    return YES;
}

@end
