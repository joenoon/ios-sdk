//
//  ParseBackend.m
//  Example
//
//  Created by Miha Gresak on 21/09/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

#import "ParseBackend.h"
#import <Parse/Parse.h>

@implementation ParseBackend

NSString *const ParseApplicationID = @"BU2njCAM4ZGNHuh2meG9Ca3zkBjqlbUd1WSwHmGG";
NSString *const ParseClientKey = @"o7bc0AL0X2gmE5eh1doecNSJPKjS6VtpVx1kaEzG";

- (id)initWithUserId:(NSString *)userId
{
    if (self = [super init])
    {
        [self setYGclientKey:userId];
    }
    
    return self;
}

- (void)setYGclientKey:(NSString *)userId
{
    _YGclientKey = [[NSUserDefaults standardUserDefaults] objectForKey:@"YGclient_key"];
    
    if (!self.YGclientKey)
    {
        
        [Parse setApplicationId:ParseApplicationID clientKey:ParseClientKey];
        
        [PFCloud callFunctionInBackground:@"YGgetClientKey"
                           withParameters:[[NSDictionary alloc] initWithObjectsAndKeys:userId, @"userId", nil]
                                    block:^(NSString *response, NSError *error) {
                                        if (!error)
                                        {
                                            NSData *responseData = [response dataUsingEncoding:NSUTF8StringEncoding];
                                            
                                            NSError *jsonSerializationError;
                                            id jsonObject = [NSJSONSerialization JSONObjectWithData:responseData options:(NSJSONReadingMutableContainers)error:&jsonSerializationError];
                                            if (jsonSerializationError)
                                            {
                                                NSLog(@"Json serizalization error: %@", jsonSerializationError.description);
                                            }
                                            
                                            NSString *client_key = [jsonObject objectForKey:@"client_key"];
                                            if (client_key)
                                            {
                                                [[NSUserDefaults standardUserDefaults] setObject:client_key forKey:@"YGclient_key"];
                                                [[NSUserDefaults standardUserDefaults] synchronize];
                                                self.YGclientKey = client_key;
                                            }
                                        }
                                        else
                                        {
                                            NSLog(@"Error:%@", error.description);
                                        }
                                    }];
    }
}

@end
