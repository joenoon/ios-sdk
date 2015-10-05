//
//  YSGClient+InvitesShown.m
//  YesGraphSDK
//
//  Created by Nejc Vivod on 05/10/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

#import "YSGClient+InvitesShown.h"

@implementation YSGClient (InvitesShown)

- (void)updateInvitesSeen:(nonnull NSArray <YSGContact *> *)invitesShown forUserId:(nonnull NSString *)userId withCompletion:(nullable void (^)(NSError * _Nullable error))completion
{
    NSDictionary *parameters = @
        {
            @"user_id": userId,
            @"data": invitesShown
        };
    
    // NOTE: change this endpoint once it's established
    [self POST:@"suggested-seen" parameters:parameters completion:^(YSGNetworkResponse * _Nullable response, NSError * _Nullable error)
     {
         if (completion)
         {
             completion(error);
         }
     }];
}

@end
