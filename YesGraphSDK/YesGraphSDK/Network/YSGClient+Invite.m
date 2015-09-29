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

- (void)updateInvitesSent:(nonnull NSArray <YSGContact *> *)invites completion:(YSGNetworkRequestCompletion)completion
{
    //
    // Currently sending only one invite to endpoint since YSG API does not support multiples yet
    // IT is possible to send POST request for each invite sent - but this is not implemented in the following code
    //
    
    if (invites.count)
    {
        NSMutableDictionary *parameter = [NSMutableDictionary new];
        
        parameter[@"user_id"] = [YesGraph shared].userId;
        parameter[@"sent_at"] = [NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970]];
        
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
                 completion(response.responseObject, error);
             }
         }];
    }
}

- (void)updateInvitesAccepted:(nonnull NSArray <YSGContact *> *)invites completion:(nonnull YSGNetworkRequestCompletion)completion
{
    //
    // Currently sending only one invite since YSG API does not support multiples yet
    // IT is possible to send POST request for each invite accepted - but this is not implemented in the following code
    //
    
    if (invites.count)
    {
        NSMutableDictionary *parameter = [NSMutableDictionary new];
        
        parameter[@"new_user_id"] = [YesGraph shared].userId;
        parameter[@"accepted_at"] = [NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970]];
        
        if (invites.lastObject.email) {
            parameter[@"email"] = invites.lastObject.email;
        }
        else if (invites.lastObject.phone) {
            parameter[@"phone"] = invites.lastObject.phone;
        }
        
        [self POST:@"invite-accepted" parameters:parameter completion:^(YSGNetworkResponse * _Nullable response, NSError * _Nullable error)
         {
             if (completion)
             {
                 completion(response.responseObject, error);
             }
         }];
    }
}
@end
