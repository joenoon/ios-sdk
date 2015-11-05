//
//  YSGMockClient.m
//  YesGraphSDK
//
//  Created by Nejc Vivod on 21/10/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

#import "YSGMockClient.h"
#import "YSGClient+AddressBook.h"
#import "YSGClient+SuggestionsShown.h"
#import "YSGTestMockData.h"
#import "YSGTestSettings.h"
#import "objc/runtime.h"

@implementation YSGMockClient

- (void)fetchAddressBookForUserId:(NSString *)userId completion:(YSGNetworkFetchCompletion)completion
{
    if (completion)
    {
        if (self.shouldSucceed)
        {
            completion([YSGTestMockData mockContactList], nil);
        }
        else
        {
            NSError *sentError = [NSError errorWithDomain:@"YesGraphSDKDomain" code:2 userInfo:nil];
            completion(nil, sentError);
        }
    }
}

- (void)updateSuggestionsSeen:(NSArray<YSGContact *> *)suggestionsShown forUserId:(NSString *)userId completion:(void (^)(NSError * _Nullable))completion
{
    if (self.shouldSucceed && self.completionHandler)
    {
        self.completionHandler(suggestionsShown, userId, completion);
    }
    else if (completion)
    {
        NSError *sentError = [NSError errorWithDomain:@"YesGraphSDKDomain" code:2 userInfo:nil];
        completion(sentError);
    }
}

+ (YSGClient * _Nonnull)createMockedClient:(BOOL)shouldSucceed
{
    YSGMockClient *newClient = [YSGMockClient new];
    newClient.clientKey = YSGTestClientKey;
    newClient.shouldSucceed = shouldSucceed;
    return newClient;
}

@end
