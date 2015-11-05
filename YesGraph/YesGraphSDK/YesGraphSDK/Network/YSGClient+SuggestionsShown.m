//
//  YSGClient+InvitesShown.m
//  YesGraphSDK
//
//  Created by Nejc Vivod on 05/10/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

#import "YSGClient+SuggestionsShown.h"
#import "YSGUtility.h"

@implementation YSGClient (SuggestionsShown)

- (NSArray <NSDictionary *> *)generateArrayOfSuggestionsFrom:(NSArray <YSGContact *> *)suggestions withUserId:(NSString *)userId
{
    NSMutableArray *ret = [[NSMutableArray alloc] initWithCapacity:suggestions.count];
    NSArray *emptyArray = [NSArray new];
    NSString *seenAt = [YSGUtility iso8601dateStringFromDate:[NSDate date]];
    
    for (YSGContact *contact in suggestions)
    {
        NSDictionary *seenContact = @
        {
            @"user_id": userId,
            @"name": contact.name,
            @"emails": contact.emails ?: emptyArray,
            @"phones": contact.phones ?: emptyArray,
            @"seen_at": seenAt
        };
        
        [ret addObject:seenContact];
    }
    
    return ret;
}

- (void)updateSuggestionsSeen:(NSArray <YSGContact *> *)suggestionsShown forUserId:(NSString *)userId completion:(nullable void (^)(NSError * _Nullable error))completion
{
    NSDictionary *parameters = @
    {
        @"entries": [self generateArrayOfSuggestionsFrom:suggestionsShown withUserId:userId]
    };
    
    [self POST:@"suggested-seen" parameters:parameters completion:^(YSGNetworkResponse * _Nullable response, NSError * _Nullable error)
    {   
        if (completion)
        {
            completion(error);
        }
    }];
}

@end
