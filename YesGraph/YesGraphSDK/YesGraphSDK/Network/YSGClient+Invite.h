//
//  YSGClient+Invite.h
//  YesGraphSDK
//
//  Created by Dal Rupnik on 02/09/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

#import "YSGClient.h"
#import "YSGContact.h"

NS_ASSUME_NONNULL_BEGIN

@interface YSGClient (Invite)

/*!
 *  This notifies YesGraph which invites were sent
 *
 *  @param invites    contacts that were invited
 *  @param userId     user's ID 
 *  @param completion called when completed
 */
- (void)updateInvitesSent:(NSArray<YSGContact *> *)invites forUserId:(NSString *)userId completion:(nullable void (^)(NSError *_Nullable error))completion;

@end

NS_ASSUME_NONNULL_END
