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
 *  @param userId     user's ID 
 *  @param completion called when completed
 */
- (void)updateInvitesSent:(nonnull NSArray<YSGContact *> *)invites
                forUserId:(nonnull NSString *)userId
           withCompletion:(nullable void (^)(NSError *_Nullable error))completion;

@end
