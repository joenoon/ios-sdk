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
 *  @param invites    contacts that were invited
 *  @param completion called when completed
 */
- (void)updateInviteSent:(nonnull NSArray <YSGContact *> *)invites completion:(void (^)(NSError  * _Nullable error))completion;

@end
