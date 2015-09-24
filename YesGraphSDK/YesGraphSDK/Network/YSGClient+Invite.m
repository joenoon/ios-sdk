//
//  YSGClient+Invite.m
//  YesGraphSDK
//
//  Created by Dal Rupnik on 02/09/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

#import "YSGClient+Invite.h"

@implementation YSGClient (Invite)

- (void)updateInviteSentToContacts:(nonnull NSArray<YSGContact *> *)invited
                         forUserId:(nonnull NSString *)userId
                    withCompletion:(nullable void (^)(NSError *_Nullable error))completion
{
    for (YSGContact *contact in invited)
    {
        [self updateInviteSentToContact:contact
                              forUserId:userId
                         withCompletion:completion];
    }
}

- (void)updateInviteSentToContact:(nonnull YSGContact *)invitee
                        forUserId:(nonnull NSString *)userId
                   withCompletion:(nullable void (^)(NSError *_Nullable error))completion
{

    NSMutableDictionary *parameter = [NSMutableDictionary new];
    parameter[@"user_id"] = userId;
    if (invitee.email)
    {
        parameter[@"email"] = invitee.email;
    }
    else if (invitee.phone)
    {
        parameter[@"phone"] = invitee.phone;
    }

    [self POST:@"invite-sent" parameters:parameter completion:^(YSGNetworkResponse * _Nullable response, NSError * _Nullable error)
    {
        if (completion)
        {
            completion(error);
        }
    }];
}

- (void)updateInviteAceptedBy:(nonnull YSGContact *)invitee
               withCompletion:(nullable void (^)(NSError *_Nullable error))completion
{
    [self updateInviteAceptedBy:invitee forNewUserId:nil withCompletion:completion];
}

- (void)updateInviteAceptedBy:(nonnull YSGContact *)invitee
                 forNewUserId:(nullable NSString *)randomUserId
               withCompletion:(nullable void (^)(NSError *_Nullable error))completion
{
    NSMutableDictionary *parameter = [NSMutableDictionary new];
    if (randomUserId)
    {
        parameter[@"new_user_id"] = randomUserId;
    }
    if (invitee.email)
    {
        parameter[@"email"] = invitee.email;
    }
    else if (invitee.phone)
    {
        parameter[@"phone"] = invitee.phone;
    }
    [self POST:@"invite-accepted" parameters:parameter completion:^(YSGNetworkResponse * _Nullable response, NSError * _Nullable error)
    {
        if (completion)
        {
            completion(error);
        }
    }];
}

@end
