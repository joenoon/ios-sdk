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
 *  @param invited    contacts that were invited
 *  @param completion called when completed
 *  @param userId     user_id 
 */

- (void)updateInviteSentToContacts:(nonnull NSArray<YSGContact *> *)invited
                         forUserId:(nonnull NSString *)userId
                    withCompletion:(nullable void (^)(NSError * _Nullable error))completion;

/*!
 *  This notifies YesGraph that the invite was sent to the specified contact
 *
 *  @param invitee    contact that was invited
 *  @param completion called when completed
 *  @param userId     user_id 
 */

- (void)updateInviteSentToContact:(nonnull YSGContact *)invitee
                        forUserId:(nonnull NSString *)userId
                   withCompletion:(nullable void (^)(NSError * _Nullable error))completion;

@end
