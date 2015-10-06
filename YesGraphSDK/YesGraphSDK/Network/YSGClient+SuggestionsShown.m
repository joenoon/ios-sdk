//
//  YSGClient+InvitesShown.m
//  YesGraphSDK
//
//  Created by Nejc Vivod on 05/10/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

#import "YSGClient+SuggestionsShown.h"

@implementation YSGClient (SuggestionsShown)

- (NSArray <NSDictionary *> *)generateArrayOfSuggestionsFrom:(NSArray <YSGContact *> *)suggestions withUserId:(NSString *)userId
{
    NSMutableArray *ret = [[NSMutableArray alloc] initWithCapacity:suggestions.count];

    NSArray *emptyArray = [NSArray new];

    NSDateFormatter *isoFormat = [NSDateFormatter new];
    NSLocale *posixLocale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
    isoFormat.locale = posixLocale;
    isoFormat.dateFormat = @"yyyy-MM-dd'T'HH:mm:ssZZZZZ";
    NSString *seenAt = [isoFormat stringFromDate:[NSDate date]];
    for (YSGContact *contact in suggestions)
    {
        NSDictionary *seenContact = @
         {
             @"user_id": userId,
             @"contact_name": contact.name,
             @"contact_emails": contact.emails ?: emptyArray,
             @"contact_phones": contact.phones ?: emptyArray,
             @"seen_at": seenAt
         };
        [ret addObject:seenContact];
    }
    
    return ret;
}

- (void)updateSuggestionsSeen:(nonnull NSArray <YSGContact *> *)suggestionsShown forUserId:(nonnull NSString *)userId withCompletion:(nullable void (^)(NSError * _Nullable error))completion
{
    NSDictionary *parameters = @
     {
         @"data": [self generateArrayOfSuggestionsFrom:suggestionsShown withUserId:userId]
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
