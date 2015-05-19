//
//  YesGraph.m
//  YesGraph SDK
//
//  Copyright (c) 2015 YesGraph. All rights reserved.
//

#import "YesGraph.h"


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
