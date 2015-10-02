//
//  YSGClient+Invite.m
//  YesGraphSDK
//
//  Created by Dal Rupnik on 02/09/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

#import "YSGClient+Invite.h"
#import "YesGraph.h"

@implementation YSGClient (Invite)

NS_ASSUME_NONNULL_BEGIN

- (void)updateInvitesSent:(nonnull NSArray <YSGContact *> *)invites
                forUsedId:(nonnull NSString *)userId
           withCompletion:(nullable void (^)(NSError *_Nullable error))completion
{
    //
    // Currently sending only one invite to endpoint since YSG API does not support multiples yet
    // IT is possible to send POST request for each invite sent - but this is not implemented in the following code
    //
    
    NSMutableDictionary *parameter = [NSMutableDictionary new];
    
    parameter[@"user_id"] = userId;
    // NOTE: when sent_at is a string, it must be an ISO 8601 formatted variant, otherwise this must be
    //       a number
    parameter[@"sent_at"] = [NSNumber numberWithLong:[[NSDate date] timeIntervalSince1970]];
    
    if (invites.lastObject.email) {
        parameter[@"email"] = invites.lastObject.email;
    }
    else if (invites.lastObject.phone) {
        parameter[@"phone"] = invites.lastObject.phone;
    }
    
    [self POST:@"invite-sent" parameters:parameter completion:^(YSGNetworkResponse * _Nullable response, NSError * _Nullable error)
     {
         if (completion)
         {
             completion(error);
         }
     }];
}

NS_ASSUME_NONNULL_END

@end
