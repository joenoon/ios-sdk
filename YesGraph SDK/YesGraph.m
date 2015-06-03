//
//  YesGraph.m
//  YesGraph SDK
//
//  Copyright (c) 2015 YesGraph. All rights reserved.
//

#import "YesGraph.h"
#import "YGNetworkManager.h"


@implementation YGYesGraphClient


+ (instancetype)sharedInstance {
    static dispatch_once_t dispatch_token;
    static YGYesGraphClient *client = nil;
    
    dispatch_once(&dispatch_token, ^{
        client = [[self alloc] init];
    });
    return client;
}


+ (void)configureWithClientKey:(NSString *)clientKey {
    [[self sharedInstance] setClientKey:clientKey];
}


- (void)setClientKey:(NSString *)clientKey
{
    _clientKey  = clientKey;
    
    YGNetworkManager *networkManager    = [YGNetworkManager sharedInstance];
    networkManager.clientKey            = clientKey;
}


- (void)test
{
    YGNetworkManager *networkManager    = [YGNetworkManager sharedInstance];
    NSString *urlString = @"https://api.yesgraph.com/v0/test";
    [networkManager GET:urlString parameters:nil success:^(NSURLResponse *response, NSData *responseData)
    {
        NSString *dataString    = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        NSLog(@"YesGraph Network Success - %@", dataString);
    }
                failure:^(NSURLResponse *response, NSData *responseData, NSError *error)
    {
        NSString *errorString   = [[error userInfo] description];
        NSLog(@"YesGraph Network Failure - %@", errorString);
    }];
}


// TODO: IMPLEMENT
/*
- (void)identifyWithTraits:(NSDictionary *)traits {
}


- (void)promptForAddressBookAccess {
}


- (NSArray *)readAddressBook {
}


- (void)sendAddressBook {
}


- (void)sendAddressBookIfNeeded {
}


- (void)rankedAddressBook {
}


- (void)rankedAddressBookWithLimit:(NSInteger)limit {
}
*/

@end
