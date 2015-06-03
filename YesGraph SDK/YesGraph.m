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


- (void)postAddressBook
{
    if (nil == _userId)
    {
        NSLog(@"YesGraph Error - postAddressBook requires the user_id parameter to be set");
        return;
    }
    
    // HACK for testing
    NSMutableDictionary *HACK_DATA      = [[NSMutableDictionary alloc] init];
    HACK_DATA[@"user_id"]               = _userId;
    HACK_DATA[@"source"]                = [NSDictionary dictionaryWithObjectsAndKeys:
                                           @"Erik Olson", @"name",
                                           @"erik@yesgraph.com", @"email",
                                           @"gmail", @"type",
                                           nil];
    NSMutableArray *HACK_ENTRY_ARRAY    = [[NSMutableArray alloc] init];
    NSDictionary *HACK_ENTRY_1          = [NSDictionary dictionaryWithObjectsAndKeys:
                                           @"Ivan Kirigin", @"name",
                                           @[@"ivan@yesgraph.com"], @"emails",
                                           @[@"+1 555 123 4567"], @"phones",
                                           @{@"picture_url":@"https://media.licdn.com/mpr/mpr/shrinknp_400_400/p/5/000/20f/182/1a51498.jpg"}, @"data",
                                           nil];
    NSDictionary *HACK_ENTRY_2          = [NSDictionary dictionaryWithObjectsAndKeys:
                                           @"Jonathan Chu", @"name",
                                           [NSArray arrayWithObjects:@"jonathan.chu@me.com", nil], @"emails",
                                           nil];
    NSDictionary *HACK_ENTRY_3          = [NSDictionary dictionaryWithObjectsAndKeys:
                                           @"Vincent Driessen", @"name",
                                           [NSArray arrayWithObjects:@"me@nvie.com", @"vincent@yesgraph.com", nil], @"emails",
                                           nil];
    NSDictionary *HACK_ENTRY_4          = [NSDictionary dictionaryWithObjectsAndKeys:
                                           [NSArray arrayWithObjects:@"post@posterous.com", nil], @"emails",
                                           nil];
    NSDictionary *HACK_ENTRY_5          = [NSDictionary dictionaryWithObjectsAndKeys:
                                           [NSArray arrayWithObjects:@"hous-123456@craigslist.org", nil], @"emails",
                                           nil];
    NSDictionary *HACK_ENTRY_6          = [NSDictionary dictionaryWithObjectsAndKeys:
                                           @"George Hickman", @"name",
                                           [NSArray arrayWithObjects:@"george@yesgraph.com", nil], @"emails",
                                           [NSDictionary dictionaryWithObjectsAndKeys:@"foo", @"bar", nil], @"data",
                                           nil];
    [HACK_ENTRY_ARRAY addObject:HACK_ENTRY_1];
    [HACK_ENTRY_ARRAY addObject:HACK_ENTRY_2];
    [HACK_ENTRY_ARRAY addObject:HACK_ENTRY_3];
    [HACK_ENTRY_ARRAY addObject:HACK_ENTRY_4];
    [HACK_ENTRY_ARRAY addObject:HACK_ENTRY_5];
    [HACK_ENTRY_ARRAY addObject:HACK_ENTRY_6];
    HACK_DATA[@"entries"]               = HACK_ENTRY_ARRAY;
    
    
    YGNetworkManager *networkManager    = [YGNetworkManager sharedInstance];
    NSString *urlString = @"https://api.yesgraph.com/v0/address-book";
    [networkManager POST:urlString parameters:HACK_DATA success:^(NSURLResponse *response, NSData *responseData)
     {
     }
                failure:^(NSURLResponse *response, NSData *responseData, NSError *error)
     {
     }];
}


// Fetching Data
- (void)fetchRankedAddressBook
{
    if (nil == _userId)
    {
        NSLog(@"YesGraph Error - fetchAddressBook requires the user_id parameter to be set");
        return;
    }
    
    YGNetworkManager *networkManager    = [YGNetworkManager sharedInstance];
    NSString *urlString                 = [NSString stringWithFormat:@"https://api.yesgraph.com/v0/address-book/%@", _userId];
    
    [networkManager GET:urlString parameters:nil success:^(NSURLResponse *response, NSData *responseData)
     {
     }
                failure:^(NSURLResponse *response, NSData *responseData, NSError *error)
     {
     }];
}


- (void)fetchRankedAddressBookWithCompletionHandler:(void (^)(NSDictionary *, NSError *))completionHandler
{
    if (nil == _userId)
    {
        NSLog(@"YesGraph Error - fetchAddressBook requires the user_id parameter to be set");
        return;
    }
    
    YGNetworkManager *networkManager    = [YGNetworkManager sharedInstance];
    NSString *urlString                 = [NSString stringWithFormat:@"https://api.yesgraph.com/v0/address-book/%@", _userId];
    
    [networkManager GET:urlString parameters:nil success:^(NSURLResponse *response, NSData *responseData)
     {
         NSError *error;
         NSDictionary *addressBook  = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&error];
         completionHandler(addressBook, error);
     }
                failure:^(NSURLResponse *response, NSData *responseData, NSError *error)
     {
         completionHandler(nil, error);
     }];
}



- (void)test
{    
    YGNetworkManager *networkManager    = [YGNetworkManager sharedInstance];
    NSString *urlString                 = @"https://api.yesgraph.com/v0/test";
    
    [networkManager GET:urlString parameters:nil success:^(NSURLResponse *response, NSData *responseData)
    {
    }
                failure:^(NSURLResponse *response, NSData *responseData, NSError *error)
    {
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
