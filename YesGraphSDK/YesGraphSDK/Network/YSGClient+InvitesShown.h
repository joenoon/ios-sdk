//
//  YSGClient+InvitesShown.h
//  YesGraphSDK
//
//  Created by Nejc Vivod on 05/10/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

#import "YSGClient.h"
#import "YSGContactList.h"

@interface YSGClient (InvitesShown)

/*!
 *  This send all shown invites to YesGraph
 *
 *  @param  invitesShown list of all the contact suggestions shown to the user
 *  @param  userId       user's ID
 *  @param  completion   called when completed
 *
 */
- (void)updateInvitesSeen:(nonnull NSArray <YSGContact *> *)invitesShown forUserId:(nonnull NSString *)userId withCompletion:(nullable void (^)(NSError * _Nullable error))completion;

@end
