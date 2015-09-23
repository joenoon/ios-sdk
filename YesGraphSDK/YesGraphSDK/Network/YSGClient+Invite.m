//
//  YSGClient+Invite.m
//  YesGraphSDK
//
//  Created by Dal Rupnik on 02/09/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

#import "YSGClient+Invite.h"

@implementation YSGClient (Invite)

- (void)updateInviteSent:(NSArray<YSGContact *> *)invites completion:(void (^)(NSError *_Nullable))completion
{
    [self POST:@"invite-sent" parameters:nil completion:^(YSGNetworkResponse * _Nullable response, NSError * _Nullable error)
    {
        if (completion)
        {
            completion(error);
        }
    }];
}

@end
