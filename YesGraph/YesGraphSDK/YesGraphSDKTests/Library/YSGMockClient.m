//
//  YSGMockClient.m
//  YesGraphSDK
//
//  Created by Nejc Vivod on 21/10/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

#import "YSGMockClient.h"
#import "YSGClient+AddressBook.h"
#import "YSGTestMockData.h"
#import "YSGTestSettings.h"
#import "objc/runtime.h"

@implementation YSGMockClient

- (void)mockedFetchAddressBookForUserId:(NSString *)userId completion:(nullable YSGNetworkFetchCompletion)completion
{
    if (completion)
    {
        completion([YSGTestMockData mockContactList], nil);
    }
}

- (void)mockedUpdateAddressBookWithContactList:(YSGContactList *)contactList forUserId:(NSString *)userId completion:(nullable YSGNetworkFetchCompletion)completion
{
    if (completion)
    {
        NSDictionary *responseObject = @
         {
             @"message": @"Address book added",
             @"batch_id": @"e8e38d79-1d2b-466f-8aa1-02c3ca7479d5"
         };
        completion(responseObject, nil);
    }
}

- (void)mockedFailingFetchAddressBookForUserId:(NSString *)userId completion:(nullable YSGNetworkFetchCompletion)completion
{
    if (completion)
    {
        NSError *sentError = [NSError errorWithDomain:@"YesGraphSDKDomain" code:2 userInfo:nil];
        completion(nil, sentError);
    }
}

- (void)mockedFailingUpdateAddressBookWithContactList:(YSGContactList *)contactList forUserId:(NSString *)userId completion:(nullable YSGNetworkFetchCompletion)completion
{
    if (completion)
    {
        NSError *sentError = [NSError errorWithDomain:@"YesGraphSDKDomain" code:2 userInfo:nil];
        completion(nil, sentError);
    }
}

- (void)swizzleMethodSelector:(SEL)original withReplacement:(SEL)replacement forInstance:(YSGClient *)client
{
    Method originalMethod = class_getInstanceMethod([client class], original);
    Method replacementMethod = class_getInstanceMethod([self class], replacement);
    method_exchangeImplementations(originalMethod, replacementMethod);
}

- (YSGClient *)createMockedClient:(BOOL)shouldSucceed
{
    YSGClient *newClient = [YSGClient new];
    newClient.clientKey = YSGTestClientKey;

    SEL originalFetch = NSSelectorFromString(@"fetchAddressBookForUserId:completion:");
    SEL originalUpdate = NSSelectorFromString(@"updateAddressBookWithContactList:completion:");

    SEL replacementFetch, replacementUpdate;
    if (shouldSucceed)
    {
        replacementFetch = NSSelectorFromString(@"mockedFetchAddressBookForUserId:completion:");
        replacementUpdate = NSSelectorFromString(@"mockedUpdateAddressBookWithContactList:completion:");
    }
    else
    {
        replacementFetch = NSSelectorFromString(@"mockedFailingFetchAddressBookForUserId:completion:");
        replacementUpdate = NSSelectorFromString(@"mockedFailingUpdateAddressBookWithContactList:completion:");
    }
    
    [self swizzleMethodSelector:originalFetch withReplacement:replacementFetch forInstance:newClient];
    [self swizzleMethodSelector:originalUpdate withReplacement:replacementUpdate forInstance:newClient];
    
    return newClient;
}

@end
