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
 *  This notifies YesGraph that the invite was sent to the specified contact
 *
 *  @param invitee    contact that was invited
 *  @param completion called when completed
 *  @param userId     user_id 
 */

- (void)updateInviteSentToContact:(nonnull YSGContact *)invitee
                        forUserId:(nonnull NSString *)userId
                   withCompletion:(nullable void (^)(NSError *_Nullable error))completion;

/*!
 *  This method is called when the user accepts an invite
 *  @param invitee      contact that accepted the invite (must have either email or phone string set)
 *  @param randomUserId randomly generated user ID, can also be nil
 *  @param completion   called when completed
 */
- (void)updateInviteAceptedBy:(nonnull YSGContact *)invitee
                 forNewUserId:(nullable NSString *)randomUserId
               withCompletion:(nullable void (^)(NSError *_Nullable error))completion;


/*!
 *  This method is called when the user accepts an invite
 *  @param invitee      contact that accepted the invite (must have either email or phone string set)
 *  @param completion   called when completed
 */
- (void)updateInviteAceptedBy:(nonnull YSGContact *)invitee
               withCompletion:(nullable void (^)(NSError *_Nullable error))completion;

@end
