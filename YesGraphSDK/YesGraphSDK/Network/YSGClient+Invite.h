//
//  YSGClient+Invite.h
//  YesGraphSDK
//
//  Created by Dal Rupnik on 02/09/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

#import "YSGClient.h"
#import "YSGContact.h"

@interface YSGClient (Invite)

/*!
 *  This notifies YesGraph which invites were sent
 *
 *  @param invite     contacts that were invited
 *  @param completion called when completed
 */
- (void)updateInvitesSent:(nonnull NSArray<YSGContact *> *)invites completion:(nonnull YSGNetworkRequestCompletion)completion;

/*!
 *  This notifies YesGraph which invites were accepted
 *
 *  @param invite     contacts that were invited
 *  @param completion called when completed
 */
- (void)updateInvitesAccepted:(nonnull NSArray<YSGContact *> *)invites completion:(nonnull YSGNetworkRequestCompletion)completion;

@end
