//
//  AppDelegate.m
//  Example
//
//  Created by Dal Rupnik on 18/08/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>
#import "ParseBackend.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    ParseBackend *parse = [[ParseBackend alloc] init];
    NSLog(@"Yes Graph client key: %@", parse.YGclientKey);
    
    return YES;
}

@end
