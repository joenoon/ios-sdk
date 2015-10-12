//
//  YSGClient+Invite.m
//  YesGraphSDK
//
//  Created by Dal Rupnik on 02/09/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

#import "YSGClient+Invite.h"
#import "YesGraph.h"
#import "YSGUtility.h"

@implementation YSGClient (Invite)

NS_ASSUME_NONNULL_BEGIN

- (NSArray <NSDictionary *> *)generateArrayOfInviteesFrom:(NSArray <YSGContact *> *)invitees withUserId:(NSString *)userId
{
    NSMutableArray *ret = [[NSMutableArray alloc] initWithCapacity:invitees.count];
    NSString *sent_at = [YSGUtility iso8061dateStringFromDate:[NSDate date]];

    for (YSGContact *c in invitees)
    {
        NSMutableDictionary *inviteSent = [NSMutableDictionary dictionaryWithDictionary:@
        {
            @"user_id": userId,
            @"invitee_name": c.name,
            @"sent_at": sent_at
        }];
        if (c.phones.count > 0)
        {
            [inviteSent setObject:c.phones[0] forKey:@"phone"];
        }
        if (c.emails.count > 0)
        {
            [inviteSent setObject:c.emails[0] forKey:@"email"];
        }
        [ret addObject:inviteSent];
    }

    return ret;
}

- (void)updateInvitesSent:(nonnull NSArray <YSGContact *> *)invites
                forUserId:(nonnull NSString *)userId
           withCompletion:(nullable void (^)(NSError *_Nullable error))completion
{
    NSDictionary *payload = @
    {
        @"entries": [self generateArrayOfInviteesFrom:invites withUserId:userId]
    };
    
    [self POST:@"invites-sent" parameters:payload completion:^(YSGNetworkResponse * _Nullable response, NSError * _Nullable error)
     {
         if (completion)
         {
             completion(error);
         }
     }];
}

NS_ASSUME_NONNULL_END

@end
